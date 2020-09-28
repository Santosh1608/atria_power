defmodule AtriaPowerWeb.DataPacketController do
  use AtriaPowerWeb, :controller

  alias AtriaPower.Sensors

  def index(conn, params) do
    data_packets = Sensors.list_data_packets(params)
    render(conn, "index.html", data_packets: data_packets)
  end

  def create(conn, params) do
    IO.inspect(params, label: "The params......")
    data_packet_params = conn.body_params

    case Sensors.create_data_packet(data_packet_params) do
      {:ok, data_packet} ->
        conn
        |> put_flash(:info, "Data packet created successfully.")
        |> redirect(to: Routes.data_packet_path(conn, :index, data_packet))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:info, "Data packet creation failed")
        |> redirect(to: Routes.data_packet_path(conn, :index))
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
