defmodule ElixirBear.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :title, :string
      add :system_prompt, :text

      timestamps(type: :utc_datetime)
    end
  end
end
