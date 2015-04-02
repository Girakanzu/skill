defmodule Entice.Skill.Mixfile do
  use Mix.Project

  def project do
    [app: :entice_skill,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  defp deps do
    [{:entice_utils, github: "entice/utils", ref: "130358824184c25e6556d3abadf6634d8c6ab5ec"},
     {:inflex, "~> 0.2.5"}]
  end
end
