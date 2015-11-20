defmodule Bolt.Mixfile do
  use Mix.Project

  def project do
    [app: :bolt,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :yaml_elixir, :eex]]
  end

  def escript do
    [main_module: Bolt.Cli, embed_elixir: true]
  end

  defp deps do
    [
      {:earmark, "~> 0.1.15"},
      { :yaml_elixir, github: "KamilLelonek/yaml-elixir" },
      { :yamerl, github: "yakaz/yamerl" }
    ]
  end
end
