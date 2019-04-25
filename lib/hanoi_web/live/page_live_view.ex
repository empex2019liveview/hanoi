defmodule HanoiWeb.PageLiveView do
  use Phoenix.LiveView
  import HanoiWeb.Gettext

  def render(assigns) do
    HanoiWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket |> assign_game()}
  end

  def handle_event("inc", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.inc(&1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.dec(&1))}
  end

  defp assign_game(socket) do
    socket
    |> assign(:game, Hanoi.new_game())
  end
end
