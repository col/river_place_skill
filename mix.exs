defmodule RiverPlaceSkill.Mixfile do
  use Mix.Project

  def project do
    [app: :river_place_skill,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :alexa, :river_place]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:alexa, "~> 0.1.11"},
      {:river_place, github: "col/river_place"},
      {:pavlov, git: "https://github.com/sproutapp/pavlov", only: :test}
    ]
  end
end
