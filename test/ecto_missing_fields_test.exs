defmodule EctoMissingFieldsTest do
  use ExUnit.Case
  doctest EctoMissingFields
  import EctoMissingFields

  setup do
    Application.put_env(:missing_fields, :enabled, true)

    :ok
  end

  defmodule TestSchema do
    use Ecto.Schema
    import Ecto
    import Ecto.Changeset

    schema "test" do
      field :foo, :integer
      field :bar, :integer
      field :baz, :integer

      field :virtual_test, :string, virtual: true

      timestamps
    end
  end

  test "passes when all fields are present" do
    assert [] == missing_fields(changeset(~w(foo baz), ~w(bar)))
  end

  test "fails when fields are missing" do
    assert [:baz] == missing_fields(changeset(~w(foo), ~w(bar)))
  end

  test "raises with fields missing" do
    assert_raise RuntimeError, ~r/missing fields/, fn ->
      changeset(~w(foo), ~w(bar))
      |> check_missing_fields!
    end
  end

  test "ignores specified fields" do
    changeset = changeset(~w(foo), ~w(bar))
    assert changeset == check_missing_fields!(changeset, ignore: [:baz])
  end

  test "does not run when disabled" do
    Application.put_env(:ecto_missing_fields, :enabled, false)
    on_exit fn ->
      Application.put_env(:ecto_missing_fields, :enabled, true)
    end

    changeset = changeset(~w(foo), ~w(bar))
    assert changeset == check_missing_fields!(changeset)
  end

  defp changeset(required, optional) do
    Ecto.Changeset.cast(%TestSchema{}, :empty, required, optional)
  end
end
