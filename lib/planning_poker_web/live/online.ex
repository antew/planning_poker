defmodule PlanningPokerWeb.Online do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="px-3 py-2 text-gray-900">
      <div class="border-b-2 -mx-3 px-3 pb-1 uppercase tracking-wider">Connected</div>
      <ul class="mt-3">
        <%= for user <- @users do %>
          <div class="flex items-center">
            <%= if user.presence != nil do %>
              <span class="w-2 h-2 inline-block bg-green-300 rounded-full"></span>
            <% else %>
              <span class="w-2 h-2 inline-block bg-red-300 rounded-full"></span>
            <% end %>
            <span class="ml-2">
              <%= user.username || "Anonymous" %>
            </span>
          </div>
        <% end %>
      </ul>
    </div>
    """
  end
end
