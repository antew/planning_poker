defmodule PlanningPokerWeb.PokerRoom do
  use Phoenix.LiveView
  alias PlanningPokerWeb.Presence
  alias PlanningPoker.PokerAgent

  def render(assigns) do
    ~L"""
      <div class="flex flex-col lg:flex-row w-full mt-6 px-4 justify-center">
        <div class="flex flex-col w-full lg:w-64">
          <%= live_component @socket,
            PlanningPokerWeb.Configuration,
            user_id: @user_id,
            username: @username,
            show_bets: @show_bets,
            users: @users,
            observers: @observers,
            points: @points,
            auto_reveal_bets: @auto_reveal_bets,
            someone_has_bet: Enum.any?(assigns.users, fn u -> u.bet != nil end)
          %>
        </div>
        <div class="flex flex-1 flex-col px-0 lg:px-6 mt-3 lg:mt-0">
          <div class="flex flex-wrap">
            <fieldset class="w-full" <%= if MapSet.member?(@observers, @user_id) do %>disabled<% end %>>
              <%= live_component @socket,
                PlanningPokerWeb.Betting,
                users: @users,
                observers: @observers,
                pointValues: String.split(@points, ",", trim: true)
              %>
            </fieldset>
          </div>
          <div class="flex w-full flex-wrap mt-6">
            <%= live_component @socket,
              PlanningPokerWeb.Board,
              users: @users,
              show_bets: @show_bets,
              observers: @observers
            %>
          </div>
        </div>
        <div class="w-full lg:w-64 h-full flex flex-col rounded border bg-white text-black shadow">
          <%= live_component @socket, PlanningPokerWeb.Online, users: @users, observers: @observers %>
        </div>
      </div>
    """
  end

  def mount(%{"id" => room_id}, _session, socket) do
    {:ok, agent} = PokerAgent.get_or_create(room_id)

    if connected?(socket) do
      PlanningPokerWeb.Endpoint.subscribe(room_id)
      user_id = get_connect_params(socket)["user_id"]
      send(self(), :after_join)
      Presence.track(self(), topic(room_id), user_id, %{})

      state = PokerAgent.state(agent)

      {:ok,
       assign(socket,
         username: PokerAgent.username(agent, user_id),
         user_id: user_id,
         users: state.users,
         room: agent,
         show_bets: state.show_bets,
         room_id: room_id,
         observers: state.observers,
         points: state.points,
         auto_reveal_bets: state.auto_reveal_bets
       )}
    else
      state = PokerAgent.state(agent)

      {:ok,
       assign(socket,
         username: "",
         user_id: nil,
         users: state.users,
         room: agent,
         show_bets: state.show_bets,
         room_id: room_id,
         observers: state.observers,
         points: state.points,
         auto_reveal_bets: state.auto_reveal_bets
       )}
    end
  end

  def handle_event("bet", %{"bet" => my_bet}, socket) do
    %{user_id: user_id, room: room} = socket.assigns
    PokerAgent.bet(room, user_id, my_bet)
    {:noreply, socket}
  end

  def handle_event("username", %{"value" => username}, socket) do
    %{user_id: user_id, room: room} = socket.assigns
    PokerAgent.update_username(room, user_id, username)
    {:noreply, assign(socket, username: username)}
  end

  defp mark_as_observer(user_id, socket) do
    %{room: room, observers: observers} = socket.assigns
    PokerAgent.update_observer(room, user_id, true)
    {:noreply, assign(socket, observer: MapSet.put(observers, user_id))}
  end

  defp unmark_as_observer(user_id, socket) do
    %{room: room, observers: observers} = socket.assigns
    PokerAgent.update_observer(room, user_id, false)
    {:noreply, assign(socket, observer: MapSet.delete(observers, user_id))}
  end

  def handle_event("toggle-self-as-observer", params, socket) do
    case params do
      %{"value" => _} ->
        unmark_as_observer(socket.assigns.user_id, socket)
      _ ->
        mark_as_observer(socket.assigns.user_id, socket)
    end
  end

  def handle_event("mark-as-observer", %{ "user-id" => user_id }, socket) do
    mark_as_observer(user_id, socket)
  end

  def handle_event("unmark-as-observer", %{ "user-id" => user_id }, socket) do
    unmark_as_observer(user_id, socket)
  end

  def handle_event("auto-reveal-bets", %{"value" => _}, socket) do
    %{room: room} = socket.assigns
    PokerAgent.set_auto_reveal_bets(room, true)
    {:noreply, assign(socket, auto_reveal_bets: true)}
  end

  def handle_event("auto-reveal-bets", _, socket) do
    %{room: room} = socket.assigns
    PokerAgent.set_auto_reveal_bets(room, false)
    {:noreply, assign(socket, auto_reveal_bets: false)}
  end

  def handle_event("show-bets", _params, socket) do
    PokerAgent.show_bets(socket.assigns.room)
    {:noreply, socket}
  end

  def handle_event("hide-bets", _params, socket) do
    PokerAgent.hide_bets(socket.assigns.room)
    {:noreply, socket}
  end

  def handle_event("clear-bets", _params, socket) do
    PokerAgent.clear_bets(socket.assigns.room)
    {:noreply, assign(socket, show_bets: false)}
  end

  def handle_event("points", %{"points" => value}, socket) do
    PokerAgent.set_points(socket.assigns.room, value)
    {:noreply, assign(socket, points: value)}
  end

  def handle_info({:change, state}, socket) do
    {:noreply,
     assign(socket,
       show_bets: state.show_bets,
       users: state.users,
       auto_reveal_bets: state.auto_reveal_bets,
       points: state.points
     )}
  end

  def handle_info({:observers_change, observers}, socket) do
    {:noreply, assign(socket, observers: observers)}
  end

  def handle_info(:show_bets, socket) do
    {:noreply, assign(socket, show_bets: true)}
  end

  def handle_info(:hide_bets, socket) do
    {:noreply, assign(socket, show_bets: false)}
  end

  def handle_info(:after_join, socket) do
    %{room: room, room_id: room_id, username: username, user_id: user_id} = socket.assigns
    PokerAgent.update_username(room, user_id, username)
    PokerAgent.presence_change(room, Presence.list(topic(room_id)))
    {:noreply, socket}
  end

  def handle_info({:update_points, points}, socket) do
    {:noreply, assign(socket, points: points)}
  end

  defp topic(room_id), do: "poker:#{room_id}"
end
