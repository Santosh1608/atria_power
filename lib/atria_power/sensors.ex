defmodule AtriaPower.Sensors do
  @moduledoc """
  The Sensors DataPackets DB queries wrapper
  """

  import Ecto.Query, warn: false
  alias AtriaPower.Repo

  alias AtriaPower.Sensors.DataPacket

  @doc """

  Returns the list of data_packets.  
  ## Examples

      iex> list_data_packets()
      [%DataPacket{}, ...]

  """
  def list_data_packets do
    query =
      from q in DataPacket,
        select: %{
          reading: q.reading,
          timestamp: q.timestamp,
          sensor_type: q.sensor_type
        }

    Repo.all(query)
  end

  def list_data_packets(filters) do
    query =
      from q in DataPacket,
        select: %{
          reading: q.reading,
          timestamp: q.timestamp,
          sensor_type: q.sensor_type
        }

    query
    |> apply_filters(filters)
    |> Repo.all()
  end

  defp prepare_filters(params) do
  end

  defp apply_filters(query, filters) do
    query =
      if range = Map.get(filters, :range) do
        from q in query,
          where: q.timestamp >= ^range.from and q.timestamp <= ^range.to
      else
        query
      end

    if sensor = Map.get(filters, :sensor_type) do
      from q in query, where: q.sesor_type == ^sensor
    else
      query
    end
  end

  def create_data_packet(attrs \\ %{}) do
    %DataPacket{}
    |> DataPacket.changeset(attrs)
    |> Repo.insert()
  end
end
