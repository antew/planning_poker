defmodule PlanningPokerWeb.Board do
  use Phoenix.LiveComponent
  def render(assigns) do
    ~L"""
    <%= for user <- @users do %>
      <div class="flex flex-col mr-3 mb-3">
        <div class="card <%= if user.vote == nil, do: 'bg-blue-900', else: 'bg-green-600' %>">
          <div class="text-6xl">
            <%= if @show_votes, do: user.vote %>
          </div>
        </div>
        <div class="w-full mt-1 text-gray-900 text-center">
          <%= if blank?(user.username), do: "Anonymous", else: user.username %>
        </div>
      </div>
    <% end %>
    """
  end

  defp blank?(nil), do: true
  defp blank?(str), do: String.length(String.trim(str)) == 0
end
