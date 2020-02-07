defmodule PlanningPoker.PokerAgent do
  use Agent
  alias Phoenix.PubSub

  defmodule State do
    defstruct(
      room_id: nil,
      users: %{},
      votes: %{},
      show_votes: false,
      presence: %{},
      observers: MapSet.new()
    )
  end

  def start_link(room_id, name) do
    Agent.start_link(fn -> %State{room_id: room_id} end, name: name)
  end

  def state(pid) do
    Agent.get(pid, fn state ->
      Enum.map(state.users, fn {user_id, username} ->
        %{
          username: username,
          user_id: user_id,
          vote: Map.get(state.votes, user_id),
          presence: Map.get(state.presence, user_id),
          observer: Map.get(state.observers, user_id)
        }
      end)
    end)
  end

  def room_id(pid) do
    Agent.get(pid, fn state -> state.room_id end)
  end

  def observers(pid) do
    Agent.get(pid, fn state -> state.observers end)
  end

  def get_show_votes(pid) do
    Agent.get(pid, fn state -> state.show_votes end)
  end

  def username(pid, user_id) do
    Agent.get(pid, fn state -> Map.get(state.users, user_id) end)
  end

  def vote(pid, user_id, vote) do
    Agent.update(pid, fn state ->
      %{state | votes: Map.put(state.votes, user_id, vote)}
    end)

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

  def show_votes(pid) do
    Agent.update(pid, fn state -> %{state | show_votes: true} end)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), :show_votes)
  end

  def hide_votes(pid) do
    Agent.update(pid, fn state -> %{state | show_votes: false} end)
    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), :hide_votes)
  end

  def clear_votes(pid) do
    Agent.update(pid, fn state ->
      %{
        state
        | votes:
            Enum.map(state.votes, fn {username, _} -> {username, nil} end)
            |> Enum.into(%{}),
          show_votes: false
      }
    end)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
  end
end
