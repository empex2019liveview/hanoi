defmodule HanoiWeb.PageController do
  use HanoiWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.Controller.live_render(conn, HanoiWeb.PageLiveView, session: %{})
  end
end
