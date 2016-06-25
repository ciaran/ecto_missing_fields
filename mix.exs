defmodule EctoMissingFields.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto_missing_fields,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package()]
  end

  def application do
    [applications: [:logger]]
  end

  defp package do
    [
      description: "Warns when creating changesets which are missing fields from the target schema.",
      maintainers: ["Ciarán Walsh"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/elixir-lang/ecto"
      },
    ]
  end

  defp deps do
    [
      {:ecto, "~> 1.1.0"}
    ]
  end
end
