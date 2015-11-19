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

  def output_path_from(content_path, location) do
    String.replace(content_path, content(location), output(location))
  end
end
