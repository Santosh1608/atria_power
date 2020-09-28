defmodule AtriaPowerWeb.DataPacketView do
  use AtriaPowerWeb, :view

  @spec timestamp(binary | non_neg_integer) :: DateTime.t()
  def timestamp(timestamp) when is_binary(timestamp) do
    timestamp
    |> String.to_integer()
    |> timestamp()
  end

  def timestamp(timestamp) do
    Timex.from_unix(timestamp, :second)
  end

  @spec fetch_chart_data(list(AtriaPower.Sensors.DataPacket)) :: [any()]
  def fetch_chart_data(data_packets) do
    Enum.map(data_packets, & &1.reading)
  end

  @spec fetch_chart_labels(list(AtriaPower.Sensors.DataPacket)) :: [String.t()]
  def fetch_chart_labels(data_packets) do
    Enum.map(data_packets, fn packet ->
      Timex.from_unix(packet.timestamp) |> to_string()
    end)
  end

  @spec today :: Date.t()
  def today() do
    Timex.today()
  end

  def avg_temp([]), do: 0.0

  def avg_temp(data_packets) do
    data_packets
    |> Enum.map(& &1.reading)
    |> Enum.sum()
    |> Kernel./(Enum.count(data_packets))
    |> Float.round(2)
  end

  def min_temp([]), do: 0.0

  def min_temp(data_packets) do
    data_packets
    |> Enum.map(& &1.reading)
    |> Enum.min()
  end

  def max_temp([]), do: 0.0

  def max_temp(data_packets) do
    data_packets
    |> Enum.map(& &1.reading)
    |> Enum.max()
  end
end
