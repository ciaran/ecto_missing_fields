# EctoMissingFields

Warns you if forgot to add a field to your `@required_fields`/`@optional_fields` list.

If you’ve added `field` definition to your Ecto schema but not added it to these lists (used in the changeset call), then the field won’t be persisted to the database. This can either lead to subtle bugs, or momentary confusion during development when adding new fields!

When enabled, an exception will be thrown if any schema fields were not passed to the changset.

# Usage

  1. Add `ecto_missing_fields` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:ecto_missing_fields, "~> 0.1.0"},
      ]
    end
    ```

  2. Use `EctoMissingFields` in your model or `web.ex` `model` macro:

      ```elixir
      def model do
        quote do
          use Ecto.Schema
          use EctoMissingFields
          …
        end
      end
      ```

  3. Add a call to `check_missing_fields!()` to the end of your model’s `changeset/2` pipeline:

    ```elixir
    def changeset(model, params \\ :empty) do
      model
      |> cast(params, @required_fields, @optional_fields)
      …
      |> check_missing_fields!()
    end
    ```

  4. You can disable checking in production using the `prod.exs` config file:

    ```elixir
    config :ecto_missing_fields,
      enabled: false
    ```
