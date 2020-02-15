defmodule PlanningPokerWeb.Board do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <%= for user <- @users do %>
      <%= if not MapSet.member?(@observers, user.user_id) do %>
        <div class="flex flex-col mr-3 mb-3">
          <div class="card <%= if user.bet == nil, do: 'bg-blue-900', else: 'bg-green-600' %>">
            <span class="transition-opacity transition-750 overflow-x-scroll <%= bets_classes(@show_bets, user.bet) %>">
              <%= if @show_bets, do: user.bet %>
            </span> 
          </div>
          <div class="w-full mt-1 text-gray-900 text-center">
            <%= if blank?(user.username), do: "Anonymous", else: user.username %>
          </div>
        </div>
      <% end %>
    <% end %>
    """
  end

  defp bets_classes(false, _), do: "opacity-0"
  defp bets_classes(true, bet), do: "opacity-100 #{bet_font_size(bet)}"
  defp bet_font_size(nil), do: ""

  defp bet_font_size(str) do
    case String.length(String.trim(str)) do
      1 ->
        "text-6xl"

      2 ->
        "text-4xl"

      3 ->
        "text-2xl"

      4 ->
        "text-base"

      5 ->
        "text-sm"

      _ ->
        "text-xs"
    end
  end

  defp blank?(nil), do: true
  defp blank?(str), do: String.length(String.trim(str)) == 0
end
