defmodule Bolt.Path do
  def layout(location) do
    Path.join(location, "layout")
  end

  def content(location) do
    Path.join(location, "content")
  end

  def output(location) do
    Path.join(location, "output")
  end

  def assets(location) do
    Path.join(location, "assets")
  end

  def output_for_content(path, location) do
    String.replace(path, content(location), output(location))
  end

  def output_for_assets(path, location) do
    String.replace(path, assets(location), output(location))
  end

  def extension(path) do
    String.split(path, ".") |> Enum.reverse |> hd
  end

  def replace_extension(path, extension) do
    parts = String.split(path, ".") |> Enum.reverse |> tl |> Enum.reverse
    Enum.join(parts ++ [extension], ".")
  end
end
