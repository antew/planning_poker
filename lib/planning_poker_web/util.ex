defmodule PlanningPokerWeb.Util do
  def blank?(nil), do: true
  def blank?(str), do: String.length(String.trim(str)) == 0
end
