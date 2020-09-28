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

  iex> list_data_packets(%{})
      [%DataPacket{}, ...]

  """
  def list_data_packets(params) do
    query =
      from q in DataPacket,
        select: %{
          reading: q.reading,
          timestamp: q.timestamp,
          sensor_type: q.sensor_type
        }

    params =
      if Map.equal?(params, %{}) do
        %{"filters" => get_default_filters()}
      else
        params
      end

    case apply_filters(query, params) do
      {:ok, query} ->
        {:ok, Repo.all(query)}

      {:error, :invalid_filters} ->
        {:error, "Filters are not valid"}
    end
  end

  defp get_default_filters() do
    today = Timex.today()

    %{
      "from_date" => %{
        "day" => today.day(),
        "month" => today.month(),
        "year" => today.year(),
        "hour" => 00,
        "minute" => 00
      },
      "to_date" => %{
        "day" => today.day(),
        "month" => today.month(),
        "year" => today.year(),
        "hour" => 23,
        "minute" => 59
      },
      sensor_type: "temp_sensor"
    }
  end

  defp from_timestamp(filters, timezone) do
    filters
    |> Map.get("from_date")
    |> frame_timestamp(timezone)
  end

  defp to_timestamp(filters, timezone) do
    filters
    |> Map.get("to_date")
    |> frame_timestamp(timezone)
  end

  defp frame_timestamp(date, timezone) do
    date =
      Map.new(date, fn
        {key, value} when is_binary(value) ->
          {key, String.to_integer(value)}

        any ->
          any
      end)

    date_tuple = {date["year"], date["month"], date["day"]}
    time_tuple = {date["hour"], date["minute"], 0}

    {date_tuple, time_tuple}
    |> Timex.to_datetime(timezone)
    |> Timex.to_unix()
  end

  defp apply_filters(query, %{"filters" => filters}) do
    sensor_type = Map.get(filters, "sensor_type")
    timezone = "Etc/UTC"

    from_timestamp = from_timestamp(filters, timezone)
    to_timestamp = to_timestamp(filters, timezone)

    if from_timestamp < to_timestamp do
      query =
        from q in query,
          where: q.timestamp >= ^from_timestamp and q.timestamp <= ^to_timestamp

      query =
        if sensor_type do
          from q in query, where: q.sensor_type == ^sensor_type
        else
          query
        end

      {:ok, query}
    else
      {:error, :invalid_filters}
    end
  end

  def create_data_packet(attrs \\ %{}) do
    %DataPacket{}
    |> DataPacket.changeset(attrs)
    |> Repo.insert()
  end
end
