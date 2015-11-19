defmodule Bolt.File do
  def layout(location) do
    File.read!(Path.join(Bolt.Path.layout(location), "application.eex"))
  end

  def content_files(location) do
    Bolt.Path.content(location)
    |> File.ls!
    |> Enum.map(fn(filename) -> Path.join(Bolt.Path.content(location), filename) end)
    |> Enum.map(fn(path) -> {path, File.read!(path)} end)
  end
end
