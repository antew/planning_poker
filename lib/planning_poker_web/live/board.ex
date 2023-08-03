defmodule PlanningPokerWeb.Board do
  use Phoenix.LiveComponent
  alias PlanningPokerWeb.Util

  def render(assigns) do
    ~H"""
    <div class="flex">
      <%= for user <- @players do %>
        <div class="flex flex-col mr-3 mb-3">
          <div class={if is_nil(user.bet), do: "card bg-blue-900", else: "card bg-green-600"}>
            <span class={bets_classes(@show_bets, user.bet)}>
              <%= if @show_bets, do: user.bet %>
            </span>
          </div>
          <div class="w-full mt-1 text-gray-900 text-center">
            <%= if Util.blank?(user.username), do: "Anonymous", else: user.username %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp bets_classes(false, _), do: "transition-opacity transition-750 opacity-0"

  defp bets_classes(true, bet),
    do: "transition-opacity transition-750 opacity-100 #{bet_font_size(bet)}"

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
end
