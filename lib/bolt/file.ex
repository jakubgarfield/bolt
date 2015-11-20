defmodule Bolt.File do
  def layout(location) do
    File.read!(Path.join(Bolt.Path.layout(location), "application.eex"))
  end

  def content_directories(location) do
    list_directories(Bolt.Path.content(location))
  end

  def content_files(location) do
    list_files(Bolt.Path.content(location))
  end

  def asset_files(location) do
    list_files(Bolt.Path.assets(location))
  end

  def asset_directories(location) do
    list_directories(Bolt.Path.assets(location))
  end

  defp list_files(location) do
    Path.wildcard(Path.join(location, "**"))
    |> Enum.reject(fn(path) -> File.dir?(path) end)
  end

  defp list_directories(location) do
    Path.wildcard(Path.join(location, "**"))
    |> Enum.filter(fn(path) -> File.dir?(path) end)
  end
end
