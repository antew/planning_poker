defmodule PlanningPokerWeb.Online do
  use Phoenix.LiveComponent
  alias PlanningPokerWeb.Util

  def render(assigns) do
    ~L"""
    <div class="px-3 py-2 text-gray-900">
      <div class="border-b-2 -mx-3 px-3 pb-1 uppercase tracking-wider">Connected</div>
      <ul class="mt-3">
        <%= for user <- @users do %>
          <div class="flex items-center">
            <%= user_info(user, assigns) %>
            <span class="ml-2 truncate">
              <%= if Util.blank?(user.username), do: "Anonymous", else: user.username %>
            </span>
          </div>
        <% end %>
      </ul>
    </div>
    """
  end

  defp user_info(user, assigns) do
    ~L"""
      <%= if MapSet.member?(@observers, user.user_id) do %>
        <button type="button"
          class="bg-gray-600 rounded-full shadow-md py-1 px-2 text-xs uppercase text-white flex-shrink-0"
          title="Click to resume as a player"
          phx-click="unmark-as-observer"
          phx-value-user-id="<%= user.user_id %>">
        <%= presence_dot(user, assigns) %>
        Observer
        </button>
      <% else %>
        <button type="button"
          class="bg-blue-500 rounded-full shadow-md py-1 px-2 text-xs uppercase text-white flex-shrink-0"
          title="Click to become an observer"
          phx-click="mark-as-observer"
          phx-value-user-id="<%= user.user_id %>">
          <%= presence_dot(user, assigns) %>
          Player
        </button>
      <% end %>
    """
  end

  defp presence_dot(user, assigns) do
    ~L"""
      <%= if user.presence != nil do %>
        <span class="flex-shrink-0 w-2 h-2 inline-block bg-green-300 rounded-full"></span>
      <% else %>
        <span class="flex-shrink-0 w-2 h-2 inline-block bg-red-300 rounded-full"></span>
      <% end %>
    """
  end
end
