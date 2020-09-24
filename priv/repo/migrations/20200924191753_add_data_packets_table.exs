defmodule AtriaPower.Repo.Migrations.AddDataPacketsTable do
  use Ecto.Migration

  def change do
    create table(:data_packets) do
      add :reading, :float
      add :timestamp, :bigint
      add :sensor_type, :string
    end
  end
end
