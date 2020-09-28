defmodule AtriaPowerWeb.DataPacketController do
  use AtriaPowerWeb, :controller

  alias AtriaPower.Sensors

  def index(conn, _params) do
    case Sensors.list_data_packets(%{}) do
      {:ok, data_packets} ->
        render(conn, "index.html", data_packets: data_packets)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def search(conn, params) do
    case Sensors.list_data_packets(params) do
      {:ok, data_packets} ->
        render(conn, "index.html", data_packets: data_packets)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def create(conn, _params) do
    data_packet_params = conn.body_params

    case Sensors.create_data_packet(data_packet_params) do
      {:ok, _data_packet} ->
        json(conn, %{data: %{status: 200, message: "Packet Deliverd"}})

      {:error, %Ecto.Changeset{} = _changeset} ->
        json(conn, %{error: %{message: "Packet Un Delivered"}})
    end
  end

  def enable(conn, %{"sensor_type" => sensor}) do
    status =
      case sensor do
        "temparature" ->
          {:ok, status} = AtriaPower.TempServer.enable()
          status

        _ ->
          :sys.get_state(AtriPower.TempServer).status
      end

    conn
    |> put_flash(:info, "Temparature Sensor has been #{status}")
    |> redirect(to: Routes.page_path(conn, :index, sensors: %{temparature: status}))
  end

  def disable(conn, %{"sensor_type" => sensor}) do
    status =
      case sensor do
        "temparature" ->
          {:ok, status} = AtriaPower.TempServer.disable()
          status

        _ ->
          :sys.get_state(AtriPower.TempServer).status
      end

    conn
    |> put_flash(:info, "Temparature Sensor has been #{status}")
    |> redirect(to: Routes.page_path(conn, :index, sensors: %{temparature: status}))
  end
end
