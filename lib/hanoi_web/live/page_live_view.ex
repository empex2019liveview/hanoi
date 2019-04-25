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
    {:noreply, socket |> update(:num_blocks, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, socket |> update(:num_blocks, &max(1, &1 - 1))}
  end

  defp assign_game(socket) do
    socket
    |> assign(:num_blocks, 4)
  end
end
