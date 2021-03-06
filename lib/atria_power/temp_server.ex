defmodule AtriaPower.TempServer do
  use GenServer
  require Logger
  @minute 60 * 1000

  @moduledoc """
  This acts as IOT server for Temperature Sesnor sending random temparatures
  """
  # Client API Calls
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{status: "disabled"}, name: __MODULE__)
  end

  def enable() do
    GenServer.call(__MODULE__, :enable)
  end

  def disable() do
    GenServer.call(__MODULE__, :disable)
  end

  # Server API Calls
  def init(state) do
    {:ok, state}
  end

  def handle_call(:enable, _from, state) do
    # Schedule packet to be sent at some point after a minute
    schedule_packet()
    {:reply, {:ok, "enabled"}, %{state | status: "enabled"}}
  end

  def handle_call(:disable, _form, state) do
    {:reply, {:ok, "disabled"}, %{state | status: "disabled"}}
  end

  def handle_info(:send_packet, state) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    reading = AtriaPower.RandomTemparature.generate()
    packet = %{timestamp: timestamp, reading: reading, sensor_type: "temp_sensor"}

    send_packet(packet)

    if state.status == "enabled" do
      schedule_packet()
    end

    {:noreply, state}
  end

  # Private Functions
  defp schedule_packet() do
    Process.send_after(self(), :send_packet, @minute)
  end

  defp send_packet(packet) do
    url = "http://localhost:4000/data_packets"
    request_data = Jason.encode!(packet)
    headers = [{"Content-type", "application/json"}]

    case HTTPoison.post(
           url,
           request_data,
           headers,
           []
         ) do
      {:ok, _response} ->
        Logger.info("Packet has been sent")

      {:error, _error} ->
        Logger.info("Error in sending the packet")
    end
  end
end
