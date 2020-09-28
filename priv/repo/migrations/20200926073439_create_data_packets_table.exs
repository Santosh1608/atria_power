defmodule AtriaPower.Repo.Migrations.CreateDataPackets do
  use Ecto.Migration

  def change do
    create table(:data_packets) do
      add :sensor_type, :string
      add :timestamp, :bigint
      add :reading, :float
    end
  end
end
