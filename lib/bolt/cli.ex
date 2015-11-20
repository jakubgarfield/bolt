defmodule Bolt.Cli do
  def main(["new", project_name]) do
    IO.puts "Creating new project #{project_name}."
    Bolt.New.run(System.cwd!, project_name)
  end

  def main(["compile"]) do
    IO.puts "Compiling..."
    Bolt.Compiler.compile(System.cwd!)
    IO.puts "Done."
  end

  def main(["help"]) do
    IO.puts "Bolt v0.0.1" # TODO: How do you get project version from MIxfile when built with escript?
    IO.puts "Some useful help goes here."
  end

  def main([command | _]) do
    IO.puts "Unrecognized command line argument: '#{command}' ( see: 'bolt help' )"
  end

  def main([]) do
    main(["help"])
  end
end
