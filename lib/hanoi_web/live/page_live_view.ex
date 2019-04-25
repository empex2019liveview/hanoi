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

  def handle_info({:tick, original_started}, socket) do
    socket
    |> update(:game, &Hanoi.tick(&1))
    |> tick(original_started)
  end

  defp assign_game(socket) do
    socket
    |> assign(:game, Hanoi.new_game())
  end

  defp tick(socket), do: tick(socket, socket.assigns[:game].started)

  defp tick(socket, original_started) do
    if connected?(socket) && socket.assigns[:game].started == original_started do
      Process.send_after(self(), {:tick, original_started}, 1000)
    end

    {:noreply, socket}
  end
end
