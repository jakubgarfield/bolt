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
    layout_path = Path.join(path, "layout")
    content_path = Path.join(path, "content")

    File.mkdir!(layout_path)
    File.mkdir!(content_path)
    File.write!(Path.join(layout_path, "application.eex"), Bolt.Template.layout)
    File.write!(Path.join(content_path, "index.eex"), Bolt.Template.index)
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
