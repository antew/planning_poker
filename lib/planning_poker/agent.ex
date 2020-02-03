defmodule PlanningPoker.PokerAgent do
  use Agent
  alias Phoenix.PubSub

  def start_link(room_id, name) do
    initial_state = %{
      room_id: room_id,
      users: %{},
      votes: %{},
      show_votes: false,
      presence: %{}
    }

    Agent.start_link(fn -> initial_state end, name: name)
  end

  def state(pid) do
    Agent.get(pid, fn state ->
      Enum.map(state.users, fn {user_id, username} ->
        %{
          username: username,
          user_id: user_id,
          vote: Map.get(state.votes, user_id),
          presence: Map.get(state.presence, user_id)
        }
      end)
    end)
  end

  def room_id(pid) do
    Agent.get(pid, fn state -> state.room_id end)
  end

  def vote(pid, user_id, vote) do
    Agent.update(pid, fn state ->
      %{state | votes: Map.put(state.votes, user_id, vote)}
    end)

    PubSub.broadcast(PlanningPoker.PubSub, room_id(pid), {:change, state(pid)})
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
