defmodule HanoiWeb.PageLiveView do
  use Phoenix.LiveView
  import HanoiWeb.Gettext

  def render(assigns) do
    HanoiWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket |> assign_game()}
  end

  def handle_event("start_game", _, socket) do
    socket
    |> update(:game, &Hanoi.start_game(&1))
    |> tick()
  end

  def handle_event("restart_game", _, socket) do
    socket
    |> update(:game, &Hanoi.restart_game(&1))
    |> tick()
  end

  def handle_event("config_game", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.new_game(&1))}
  end

  def handle_event("inc", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.inc(&1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.dec(&1))}
  end

  def handle_event("tower_a", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.pick(&1, :tower_a))}
  end

  def handle_event("tower_b", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.pick(&1, :tower_b))}
  end

  def handle_event("tower_c", _, socket) do
    {:noreply, socket |> update(:game, &Hanoi.pick(&1, :tower_c))}
  end

  def handle_info(:tick, socket) do
    socket
    |> update(:game, &Hanoi.display(&1))
    |> tick()
  end

  defp assign_game(socket) do
    socket
    |> assign(:game, Hanoi.new_game())
  end

  defp tick(socket) do
    if connected?(socket) && !socket.assigns[:game].ended() do
      Process.send_after(self(), :tick, 1000)
    end

    {:noreply, socket}
  end
end
