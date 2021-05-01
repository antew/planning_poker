defmodule PlanningPokerWeb.Configuration do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="w-full lg:max-w-md flex flex-col rounded-lg border bg-white text-black shadow-lg">
      <div class="py-6 px-4">
        <div class="border-b-2 border-gray-300 -mx-3 px-3 pb-1 uppercase tracking-wider">Configuration</div>
        <div class="flex flex-col mt-3 items-start justify-around">
          <label for="username" class="w-1/3 mb-1 uppercase text-sm tracking-wide">Username</label>
          <input
            id="username"
            class="w-full bg-gray-200 appearance-none border-2 border-gray-200 rounded p-2"
            type="text"
            name="username"
            placeholder="Your Name"
            value="<%= @username %>"
            phx-keyup="username"
            maxlength="15"
            autocomplete="name"
          />
          <form phx-change="points">
            <label for="points" class="w-2/3 mt-3 mb-1 uppercase text-sm tracking-wide">Point System</label>
            <input
              id="points"
              class="w-full bg-gray-200 appearance-none border-2 border-gray-200 rounded p-2"
              type="text"
              name="points"
              placeholder="1, 2, 3, 5, 8..."
              value="<%= @points %>"
              autocomplete="off"
              <%= if @someone_has_bet do %>
              title="The point system cannot be changed after a bet has been placed."
              disabled
              <% end %>
            />
          </form>
          <span class="mt-3 flex items-center">
            <input
              id="observer"
              type="checkbox"
              class="mr-3"
              name="observer"
              phx-click="toggle-self-as-observer"
              value="true"
              <%= if MapSet.member?(@observers, @user_id) do %> checked<% end %>
             />
            <label for="observer" class="mt-1">I'm an observer</label>
          </span>
          <span class="mt-3 flex items-center">
            <input
              id="auto-reveal-bets"
              type="checkbox"
              class="mr-3"
              name="auto-reveal-bets"
              phx-click="auto-reveal-bets"
              phx-value="<%= not @auto_reveal_bets %>"
              <%= if @auto_reveal_bets do %> checked<% end %>
             />
              <label for="auto-reveal-bets" class="mt-1">Reveal bets automatically when everyone has bet.</label>
          </span>
        </div>
        <div class="flex flex-col justify-around mt-4">
          <%= if @show_bets do %>
            <button class="btn btn-blue disabled:opacity-50 focus:outline-none focus:ring-2" type="button" phx-click="hide-bets" >Hide Bets</button>
          <% else %>
            <button
              class="btn btn-blue disabled:opacity-50 disabled:cursor-not-allowed focus:outline-none focus:ring-2"
              type="button"
              phx-click="show-bets"
              <%= if not @someone_has_bet do %>disabled<% end %>
            >Show Bets
            </button>
          <% end %>

          <button
          class="btn btn-blue mt-3 disabled:opacity-50 disabled:cursor-not-allowed focus:outline-none focus:ring-2"
          type="button"
          phx-click="clear-bets"
          <%= if not @someone_has_bet do %>disabled<% end %>
          >Clear Bets</button>
        </div>
      </div>
    </div>
    """
  end
end
