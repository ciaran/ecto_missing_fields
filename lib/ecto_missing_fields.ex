defmodule EctoMissingFields do
  @timestamp_fields [:inserted_at, :updated_at]

  defmacro __using__(_) do
    quote do
      import EctoMissingFields, only: [check_missing_fields!: 2]
    end
  end

  def enabled?,
    do: Application.get_env(:ecto_missing_fields, :enabled, true)

  def check_missing_fields!(%Ecto.Changeset{} = changeset, opts \\ []) do
    case enabled? do
      true  -> do_check_missing_fields!(changeset, opts)
      false -> changeset
    end
  end

  defp do_check_missing_fields!(%Ecto.Changeset{} = changeset, opts) do
    case missing_fields(changeset, opts) do
      [] ->
        changeset
      fields ->
        raise "Changeset for #{changeset.model.__struct__} created with missing fields: #{inspect fields}"
    end
  end

  def missing_fields(%Ecto.Changeset{} = changeset, opts \\ []) do
    model = model(changeset)

    ignored_fields = ignored_fields(model, Keyword.get(opts, :ignore, []))

    changeset_fields = changeset_fields(changeset)
    schema_fields = schema_fields(model)

    (schema_fields -- changeset_fields) -- ignored_fields
  end

  defp primary_keys(model),
    do: model.__schema__(:primary_key)

  defp ignored_fields(model, ignore),
    do: ignore ++ primary_keys(model) ++ @timestamp_fields

  defp model(%Ecto.Changeset{model: model}),
    do: model.__struct__

  def schema_fields(model),
    do: model.__schema__(:fields)

  def changeset_fields(%Ecto.Changeset{required: required, optional: optional}),
    do: required ++ optional
end
