defmodule PlanningPokerWeb.Average do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      <div :if={@show_bets} class="my-4 flex flex-col rounded-lg border bg-white text-black shadow-lg">
        <div class="px-4 py-6 text-gray-900">
          <span class="border-b-2 border-gray-300 -mx-3 px-3 pb-1 uppercase tracking-wider">
            Avg
          </span>
          <span class="mx-5">
            <span class="bg-blue-500 rounded-full shadow-md py-1 px-2 text-xs uppercase text-white flex-shrink-0">
              <%= calculate_avg(@players) %>
            </span>
          </span>
        </div>
      </div>
    </div>
    """
  end

  defp calculate_avg(players) do
    players_with_bets =
      players
      |> Enum.map(fn player -> to_integer(player.bet) end)
      |> Enum.filter(&(&1 != 0))

    if length(players_with_bets) == 0 do
      0
    else
      Float.round(Enum.sum(players_with_bets) / length(players_with_bets), 2)
    end
  end

  defp to_integer(bet) do
    bet |> String.trim() |> String.to_integer()
  rescue
    _e -> 0
  end
end
