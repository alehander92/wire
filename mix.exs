defmodule Wire.Mixfile do
  use Mix.Project

  def project do
    [app: :wire,
     version: "0.0.8",
     elixir: "~> 1.0.0",
     description: "Encode and decode bittorrent peer wire protocol messages",
     package: package,
     deps: deps]
  end

  defp package do
    [ contributors: ["alehander42"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/alehander42/wire"}]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
