defmodule Bun2.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :bun2,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Bun2",
      source_url: "https://github.com/jit-y/bun2",
      elixirc_paths: elixirc_paths(Mix.env)
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Bun2, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.8.6", only: :dev},
      {:exfmt, "~> 0.4.0", only: :dev},
    ]
  end

  defp description do
    "A Bot Framework written in Elixir"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Yuji Takahashi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jit-y/bun2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
