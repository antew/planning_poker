defmodule PlanningPoker.PokerAgent do
  use Agent
  alias Phoenix.PubSub

  defmodule State do
    defstruct(
      room_id: nil,
      users: %{},
      bets: %{},
      show_bets: false,
      presence: %{},
      observers: MapSet.new(),
      points: "1, 2, 3, 5, 8, 13, 21",
      auto_reveal_bets: false
    )
  end

  def get_or_create(room_id) do
    case Registry.lookup(Registry.PlanningPoker, room_id) do
      [] ->
        name = {:via, Registry, {Registry.PlanningPoker, room_id}}
        start_link(room_id, name)

      [{pid, _}] ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  defp start_link(room_id, name) do
    Agent.start_link(fn -> %State{room_id: room_id} end, name: name)
  end

  def state(pid) do
    Agent.get(pid, fn state ->
      users =
        Enum.map(state.users, fn {user_id, username} ->
          %{
            username: username,
            user_id: user_id,
            bet: Map.get(state.bets, user_id),
            presence: Map.get(state.presence, user_id),
            observer: Map.get(state.observers, user_id)
          }
        end)

      %{
        show_bets: state.show_bets,
        users: users,
        points: state.points,
        auto_reveal_bets: state.auto_reveal_bets,
        observers: state.observers
      }
    end)
  end

  def room_id(pid) do
    Agent.get(pid, fn state -> state.room_id end)
  end

  def observers(pid) do
    Agent.get(pid, fn state -> state.observers end)
  end

  def get_show_bets(pid) do
    Agent.get(pid, fn state -> state.show_bets end)
  end

  def username(pid, user_id) do
    Agent.get(pid, fn state -> Map.get(state.users, user_id) end)
  end

  def bet(pid, user_id, bet) do
    Agent.update(pid, fn state ->
      %{state | bets: Map.put(state.bets, user_id, bet)}
    end)

    auto_reveal_bets? = Agent.get(pid, fn state -> state.auto_reveal_bets end)
    if auto_reveal_bets?, do: reveal_bets_if_needed(pid)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end

  def update_observer(pid, user_id, observing) do
    Agent.update(pid, fn state ->
      %{
        state
        | observers:
            if(observing,
              do: MapSet.put(state.observers, user_id),
              else: MapSet.delete(state.observers, user_id)
            )
      }
    end)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:observers_change, observers(pid)})
  end

  def update_username(pid, user_id, username) do
    Agent.update(pid, fn state ->
      %{state | users: Map.put(state.users, user_id, username)}
    end)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end

  def presence_change(pid, presence) do
    Agent.update(pid, fn state -> %{state | presence: presence} end)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end

  def show_bets(pid) do
    Agent.update(pid, fn state -> %{state | show_bets: true} end)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), :show_bets)
  end

  def hide_bets(pid) do
    Agent.update(pid, fn state -> %{state | show_bets: false} end)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), :hide_bets)
  end

  def clear_bets(pid) do
    Agent.update(pid, fn state ->
      %{
        state
        | bets:
            Enum.map(state.bets, fn {username, _} -> {username, nil} end)
            |> Enum.into(%{}),
          show_bets: false
      }
    end)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end

  def set_points(pid, points) do
    Agent.update(pid, fn state -> %{state | points: points} end)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end

  def set_auto_reveal_bets(pid, enabled) do
    Agent.update(pid, fn state -> %{state | auto_reveal_bets: enabled} end)
    reveal_bets_if_needed(pid)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end

  defp reveal_bets_if_needed(pid) do
    Agent.update(pid, fn state ->
      all_bet =
        state.users
        |> Enum.all?(fn {user_id, _} ->
          MapSet.member?(state.observers, user_id) or
            Map.get(state.bets, user_id, nil) != nil
        end)

      if all_bet do
        %{state | show_bets: true}
      else
        state
      end
    end)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end
end
