defmodule AtriaPower.Sensors.DataPacket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "data_packets" do
    field :reading, :float
    field :sensor_type, :string
    field :timestamp, :integer

    timestamps()
  end

  @doc false
  def changeset(data_packet, attrs) do
    data_packet
    |> cast(attrs, [:sensor_type, :timestamp, :reading])
    |> validate_required([:sensor_type, :timestamp, :reading])
  end
end
