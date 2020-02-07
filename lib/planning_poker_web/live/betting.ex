defmodule PlanningPokerWeb.Betting do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="w-full flex flex-col rounded border bg-white text-gray-900 shadow">
      <div class="m-3">
        <div class="flex flex-wrap items-center">
          <span class="border-b-2 -mx-3 px-3 pb-1 uppercase tracking-wider">Place your bet</span>
          <div class="flex w-full flex-wrap mt-3 justify-between">
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="1">1 Point</button>
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="2">2 Points</button>
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="3">3 Points</button>
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="5">5 Points</button>
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="8">8 Points</button>
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="13">13 Points</button>
            <button class="btn btn-blue px-2 mb-2 mr-2" type="button" phx-click="bet" phx-value-bet="21">21 Points</button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
