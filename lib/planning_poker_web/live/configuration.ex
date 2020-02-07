defmodule PlanningPokerWeb.Configuration do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div class="max-w-md w-full flex flex-col rounded border bg-white text-black shadow">
      <div class="m-3">
        <div class="border-b-2 -mx-3 px-3 pb-1 uppercase tracking-wider">Configuration</div>
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
          />
          <span class="mt-3 flex items-center">
            <input 
              id="observer" 
              type="checkbox"
              class="mr-3"
              name="observer"
              phx-click="observer"
              value="true"
              <%= if MapSet.member?(@observers, @user_id) do %> checked<% end %>
             />
            <label for="observer" class="mt-1">I'm an observer</label>
          </span>
        </div>
        <div class="flex flex-col justify-around mt-4">
          <%= if @show_votes do %>
            <button class="btn btn-blue" type="button" phx-click="hide-votes">Hide Bets</button>
          <% else %>
            <button class="btn btn-blue" type="button" phx-click="show-votes">Show Bets</button>
          <% end %>
          <button class="btn btn-blue mt-3" type="button" phx-click="clear-votes">Clear Bets</button>
        </div>
      </div>
    </div>
    """
  end
end
