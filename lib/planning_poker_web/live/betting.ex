defmodule PlanningPokerWeb.Betting do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="w-full flex flex-col rounded-lg border bg-white text-gray-900 shadow-lg">
      <div class="py-6 px-4">
        <div class="flex flex-wrap items-center">
          <span class="border-b-2 border-gray-300 -mx-3 px-3 pb-1 uppercase tracking-wider">Place your bet</span>
          <div class="flex w-full flex-wrap mt-3 justify-between">
            <%= for point_val <- @pointValues do %>
              <button class="btn btn-blue px-2 mb-2 mr-2 flex-grow-default focus:outline-none focus:ring-2" type="button" phx-click="bet" phx-value-bet="<%= point_val %>">
                <%= point_val %>
              </button>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
