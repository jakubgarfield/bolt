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
    File.write!(Path.join(Bolt.Path.content(path), "index.md"), Bolt.Template.index)
  end
end
