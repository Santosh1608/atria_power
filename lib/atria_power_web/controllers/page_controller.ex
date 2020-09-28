defmodule AtriaPowerWeb.PageController do
  use AtriaPowerWeb, :controller

  def index(conn, _params) do
    temp_sensor_status = :sys.get_state(AtriaPower.TempServer).status
    render(conn, "index.html", sensors: %{temparature: temp_sensor_status})
  end
end
