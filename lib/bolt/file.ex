defmodule Bolt.File do
  def layout(location) do
    File.read!(Path.join(Bolt.Path.layout(location), "application.eex"))
  end

  def content_files(location) do
    read_files(Bolt.Path.content(location))
  end

  def asset_files(location) do
    read_files(Bolt.Path.assets(location))
  end

  defp read_files(location) do
    File.ls!(location)
    |> Enum.map(fn(filename) -> Path.join(location, filename) end)
    |> Enum.map(fn(path) -> {path, File.read!(path)} end)
  end
end
