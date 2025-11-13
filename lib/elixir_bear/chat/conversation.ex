defmodule ElixirBear.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :title, :string
    field :system_prompt, :string

    has_many :messages, ElixirBear.Chat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:title, :system_prompt])
    |> validate_required([])
  end
end
