defmodule PlanningPokerWeb.Online do
  use Phoenix.LiveComponent
  alias PlanningPokerWeb.Util

  def render(assigns) do
    ~H"""
    <div class="px-4 py-6 text-gray-900">
      <div class="border-b-2 border-gray-300 -mx-3 px-3 pb-1 uppercase tracking-wider">Connected</div>
      <ul class="mt-3 space-y-2">
        <%= for user <- @users do %>
          <div class="flex items-center">
            <%= if MapSet.member?(@observers, user.user_id) do %>
              <button
                type="button"
                class="bg-gray-600 rounded-full shadow-md py-1 px-2 text-xs uppercase text-white flex-shrink-0 focus:outline-none focus:ring-2"
                title="Click to resume as a player"
                phx-click="unmark-as-observer"
                phx-value-user-id={user.user_id}
              >
                <%= presence_dot(user.presence, assigns) %> Observer
              </button>
            <% else %>
              <button
                type="button"
                class="bg-blue-500 rounded-full shadow-md py-1 px-2 text-xs uppercase text-white flex-shrink-0"
                title="Click to become an observer"
                phx-click="mark-as-observer"
                phx-value-user-id={user.user_id}
              >
                <%= presence_dot(user.presence, assigns) %> Player
              </button>
            <% end %>
            <span class="ml-2 truncate">
              <%= if Util.blank?(user.username), do: "Anonymous", else: user.username %>
            </span>
          </div>
        <% end %>
      </ul>
    </div>
    """
  end

  defp presence_dot(nil, assigns) do
    ~H"""
    <span class="flex-shrink-0 w-2 h-2 inline-block bg-red-300 rounded-full"></span>
    """
  end

  defp presence_dot(_, assigns) do
    ~H"""
    <span class="flex-shrink-0 w-2 h-2 inline-block bg-green-300 rounded-full"></span>
    """
  end
end
