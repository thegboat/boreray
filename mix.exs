defmodule Boreray.MixProject do
  use Mix.Project

  def project do
    [
      app: :boreray,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.12"},
      {:jason, "~> 1.4"},
      {:timex, "~> 3.7"},
      {:date_time_parser, "~> 1.2"}
    ]
  end
end
