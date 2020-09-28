defmodule AtriaPower.SensorsTest do
  use AtriaPower.DataCase

  alias AtriaPower.Sensors

  describe "data_packets" do
    alias AtriaPower.Sensors.DataPacket

    @valid_attrs %{reading: 120.5, sensor_type: "some sensor_type", timestamp: 42}
    @update_attrs %{reading: 456.7, sensor_type: "some updated sensor_type", timestamp: 43}
    @invalid_attrs %{reading: nil, sensor_type: nil, timestamp: nil}

    def data_packet_fixture(attrs \\ %{}) do
      {:ok, data_packet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sensors.create_data_packet()

      data_packet
    end

    test "list_data_packets/0 returns all data_packets" do
      data_packet = data_packet_fixture()
      assert Sensors.list_data_packets() == [data_packet]
    end

    test "get_data_packet!/1 returns the data_packet with given id" do
      data_packet = data_packet_fixture()
      assert Sensors.get_data_packet!(data_packet.id) == data_packet
    end

    test "create_data_packet/1 with valid data creates a data_packet" do
      assert {:ok, %DataPacket{} = data_packet} = Sensors.create_data_packet(@valid_attrs)
      assert data_packet.reading == 120.5
      assert data_packet.sensor_type == "some sensor_type"
      assert data_packet.timestamp == 42
    end

    test "create_data_packet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sensors.create_data_packet(@invalid_attrs)
    end

    test "update_data_packet/2 with valid data updates the data_packet" do
      data_packet = data_packet_fixture()
      assert {:ok, %DataPacket{} = data_packet} = Sensors.update_data_packet(data_packet, @update_attrs)
      assert data_packet.reading == 456.7
      assert data_packet.sensor_type == "some updated sensor_type"
      assert data_packet.timestamp == 43
    end

    test "update_data_packet/2 with invalid data returns error changeset" do
      data_packet = data_packet_fixture()
      assert {:error, %Ecto.Changeset{}} = Sensors.update_data_packet(data_packet, @invalid_attrs)
      assert data_packet == Sensors.get_data_packet!(data_packet.id)
    end

    test "delete_data_packet/1 deletes the data_packet" do
      data_packet = data_packet_fixture()
      assert {:ok, %DataPacket{}} = Sensors.delete_data_packet(data_packet)
      assert_raise Ecto.NoResultsError, fn -> Sensors.get_data_packet!(data_packet.id) end
    end

    test "change_data_packet/1 returns a data_packet changeset" do
      data_packet = data_packet_fixture()
      assert %Ecto.Changeset{} = Sensors.change_data_packet(data_packet)
    end
  end
end
