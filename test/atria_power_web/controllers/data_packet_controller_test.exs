defmodule AtriaPowerWeb.DataPacketControllerTest do
  use AtriaPowerWeb.ConnCase

  alias AtriaPower.Sensors

  @create_attrs %{reading: 120.5, sensor_type: "some sensor_type", timestamp: 42}
  @update_attrs %{reading: 456.7, sensor_type: "some updated sensor_type", timestamp: 43}
  @invalid_attrs %{reading: nil, sensor_type: nil, timestamp: nil}

  def fixture(:data_packet) do
    {:ok, data_packet} = Sensors.create_data_packet(@create_attrs)
    data_packet
  end

  describe "index" do
    test "lists all data_packets", %{conn: conn} do
      conn = get(conn, Routes.data_packet_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Data packets"
    end
  end

  describe "new data_packet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.data_packet_path(conn, :new))
      assert html_response(conn, 200) =~ "New Data packet"
    end
  end

  describe "create data_packet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.data_packet_path(conn, :create), data_packet: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.data_packet_path(conn, :show, id)

      conn = get(conn, Routes.data_packet_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Data packet"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.data_packet_path(conn, :create), data_packet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Data packet"
    end
  end

  describe "edit data_packet" do
    setup [:create_data_packet]

    test "renders form for editing chosen data_packet", %{conn: conn, data_packet: data_packet} do
      conn = get(conn, Routes.data_packet_path(conn, :edit, data_packet))
      assert html_response(conn, 200) =~ "Edit Data packet"
    end
  end

  describe "update data_packet" do
    setup [:create_data_packet]

    test "redirects when data is valid", %{conn: conn, data_packet: data_packet} do
      conn = put(conn, Routes.data_packet_path(conn, :update, data_packet), data_packet: @update_attrs)
      assert redirected_to(conn) == Routes.data_packet_path(conn, :show, data_packet)

      conn = get(conn, Routes.data_packet_path(conn, :show, data_packet))
      assert html_response(conn, 200) =~ "some updated sensor_type"
    end

    test "renders errors when data is invalid", %{conn: conn, data_packet: data_packet} do
      conn = put(conn, Routes.data_packet_path(conn, :update, data_packet), data_packet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Data packet"
    end
  end

  describe "delete data_packet" do
    setup [:create_data_packet]

    test "deletes chosen data_packet", %{conn: conn, data_packet: data_packet} do
      conn = delete(conn, Routes.data_packet_path(conn, :delete, data_packet))
      assert redirected_to(conn) == Routes.data_packet_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.data_packet_path(conn, :show, data_packet))
      end
    end
  end

  defp create_data_packet(_) do
    data_packet = fixture(:data_packet)
    %{data_packet: data_packet}
  end
end
