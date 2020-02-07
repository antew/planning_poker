defmodule PlanningPokerWeb.PokerRoom do
  use Phoenix.LiveView
  alias PlanningPokerWeb.Presence
  alias PlanningPoker.PokerAgent

  def render(assigns) do
    ~L"""
    <div class="flex flex-col lg:flex-row w-full mt-6 px-4">
      <div class="flex flex-col w-full lg:w-64">
        <%= live_component @socket, 
          PlanningPokerWeb.Configuration, 
          user_id: @user_id, 
          username: @username, 
          show_votes: @show_votes, 
          observers: @observers 
        %>
      </div>
      <div class="flex flex-col px-6">
        <div class="flex flex-wrap">
          <%= live_component @socket, PlanningPokerWeb.Betting, users: @users %>
        </div>
        <div class="flex w-full flex-wrap mt-6">
          <%= live_component @socket, 
            PlanningPokerWeb.Board, 
            users: @users, 
            show_votes: @show_votes, 
            observers: @observers 
          %>
        </div>
      </div>
      <div class="w-full lg:w-64 h-full flex flex-col rounded border bg-white text-black shadow">
        <%= live_component @socket, PlanningPokerWeb.Online, users: @users %>
      </div>
    </div>
    """
  end

  def mount(%{"id" => room_id}, session, socket) do
    # Presence.track(self(), "users", name, %{})
    {:ok, agent} =
      case Registry.lookup(Registry.PlanningPoker, room_id) do
        [] ->
          name = {:via, Registry, {Registry.PlanningPoker, room_id}}
          PokerAgent.start_link(room_id, name)

        [{pid, _}] ->
          {:ok, pid}

        {:error, {:already_started, pid}} ->
          {:ok, pid}
      end

    if connected?(socket) do
      # PubSub.subscribe(PlanningPoker.PubSub, room_id)
      PlanningPokerWeb.Endpoint.subscribe(room_id)
      user_id = get_connect_params(socket)["user_id"]
      PokerAgent.update_username(agent, user_id, session["username"])
      send(self(), :after_join)
      Presence.track(self(), topic(room_id), user_id, %{})

      observers = PokerAgent.observers(agent)
      users = PokerAgent.state(agent)

      {:ok,
       assign(socket,
         username: PokerAgent.username(agent, user_id),
         user_id: user_id,
         users: users,
         room: agent,
         show_votes: PokerAgent.get_show_votes(agent),
         time: nil,
         room_id: room_id,
         observers: PokerAgent.observers(agent)
       )}
    else
      {:ok,
       assign(socket,
         username: "",
         user_id: nil,
         users: PokerAgent.state(agent),
         room: agent,
         show_votes: false,
         time: nil,
         room_id: room_id,
         observers: MapSet.new()
       )}
    end
  end

  def handle_event("bet", %{"bet" => my_bet}, socket) do
    %{user_id: user_id, room: room} = socket.assigns
    PokerAgent.vote(room, user_id, my_bet)
    {:noreply, socket}
  end

  def handle_event("username", %{"value" => username}, socket) do
    %{user_id: user_id, room: room} = socket.assigns
    PokerAgent.update_username(room, user_id, username)
    {:noreply, assign(socket, username: username)}
  end

  def handle_event("observer", %{"value" => val}, socket) do
    %{user_id: user_id, room: room, observers: observers} = socket.assigns
    PokerAgent.update_observer(room, user_id, true)
    {:noreply, assign(socket, observer: MapSet.put(observers, user_id))}
  end

  def handle_event("observer", _, socket) do
    %{user_id: user_id, room: room, observers: observers} = socket.assigns
    PokerAgent.update_observer(room, user_id, false)
    {:noreply, assign(socket, observer: MapSet.delete(observers, user_id))}
  end

  def handle_event("show-votes", _params, socket) do
    PokerAgent.show_votes(socket.assigns.room)
    {:noreply, socket}
  end

  def handle_event("hide-votes", _params, socket) do
    PokerAgent.hide_votes(socket.assigns.room)
    {:noreply, socket}
  end

  def handle_event("clear-votes", _params, socket) do
    PokerAgent.clear_votes(socket.assigns.room)
    {:noreply, assign(socket, show_votes: false)}
  end

  def handle_info({:change, users}, socket) do
    {:noreply, assign(socket, users: users)}
  end

  def handle_info({:observers_change, observers}, socket) do
    {:noreply, assign(socket, observers: observers)}
  end

  def handle_info(:show_votes, socket) do
    {:noreply, assign(socket, show_votes: true)}
  end

  def handle_info(:hide_votes, socket) do
    {:noreply, assign(socket, show_votes: false)}
  end

  def handle_info(:after_join, socket) do
    %{room: room, room_id: room_id} = socket.assigns
    PokerAgent.presence_change(room, Presence.list(topic(room_id)))
    {:noreply, socket}
  end

  defp topic(room_id), do: "poker:#{room_id}"
end
