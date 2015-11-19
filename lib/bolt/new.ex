defmodule Bolt.New do
  def run(location, name) do
    path = Path.join(location, name)
    case File.mkdir(path) do
      :ok ->
        initialize_structure(path)
      {:error, _} ->
        IO.puts(:stderr, "Couldn't create a project directory")
    end
  end

  def initialize_structure(path) do
    File.mkdir!(Bolt.Path.layout(path))
    File.mkdir!(Bolt.Path.content(path))
    File.write!(Path.join(Bolt.Path.layout(path), "application.eex"), Bolt.Template.layout)
    File.write!(Path.join(Bolt.Path.content(path), "index.eex"), Bolt.Template.index)
  end
end

defmodule Bolt.Template do
  def layout do
"""
<html>
<head>
  <title>Welcome to bolt!</title>
</head>
<body>
  <%= yield %>
</body>
</html
"""
  end

  def index do
"""
<h1>Welcome to bolt</h1>
<p>The fastest and most awesome static site generator in Elixir</p>
"""
  end
end

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

  def output_path_from(content_path, location) do
    String.replace(content_path, content(location), output(location))
  end
end

defmodule Bolt.File do
  def layouts(location) do
    Bolt.Path.layout(location)
    |> File.ls!
  end

  def content_files(location) do
    Bolt.Path.content(location)
    |> File.ls!
    |> Enum.map(fn(filename) -> Path.join(Bolt.Path.content(location), filename) end)
    |> Enum.map(fn(path) -> {path, File.read!(path)} end)
  end
end

defmodule Bolt.Compiler do
  def compile(location) do
    File.mkdir(Bolt.Path.output(location))
    Enum.map(Bolt.File.content_files(location), fn(content_file) -> 
      replace_content_path_with_output_path(content_file, location)
      |> Bolt.Renderer.render
      |> write
    end)
  end

  defp write({path, content}) do
    File.write!(path, content)
  end

  defp replace_content_path_with_output_path({path, content}, location) do
    {Bolt.Path.output_path_from(path, location), content}
  end
end

defmodule Bolt.Renderer do
  def render({path, content}) do
    {path, transform(content, [], extension(path))}
  end

  defp transform(content, _, :md) do
    Earmark.to_html(content)
  end

  defp transform(content, params, :eex) do
    EEx.eval_string(content, assigns: params)
  end

  defp transform(content, _, _) do
    content
  end

  defp extension(path) do
    String.split(path, ".") |> Enum.reverse |> hd
  end
end
