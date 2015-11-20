defmodule Bolt.Compiler do
  def compile(location) do
    File.rm_rf(Bolt.Path.output(location))
    File.mkdir(Bolt.Path.output(location))

    create_content_directories(location)
    create_assets_directories(location)

    compile_content(location)
    compile_assets(location)
  end

  defp create_assets_directories(location) do
    Bolt.File.asset_directories(location)
    |> Enum.map(fn(path) -> Bolt.Path.output_for_assets(path, location) end)
    |> Enum.map(fn(path) -> File.mkdir!(path) end)
  end

  def create_content_directories(location) do
    Bolt.File.content_directories(location)
    |> Enum.map(fn(path) -> Bolt.Path.output_for_content(path, location) end)
    |> Enum.map(fn(path) -> File.mkdir!(path) end)
  end

  defp compile_assets(location) do
    Enum.map(Bolt.File.asset_files(location), fn(path) ->
      {extension, compiled_content} = Bolt.Renderer.render(path)
      output_path = Bolt.Path.replace_extension(Bolt.Path.output_for_assets(path, location), extension)
      File.write!(output_path, compiled_content)
    end)
  end

  defp compile_content(location) do
    Enum.map(Bolt.File.content_files(location), fn(path) ->
      {extension, compiled_content} = Bolt.Renderer.render(path, Bolt.File.layout(location))
      output_path = Bolt.Path.replace_extension(Bolt.Path.output_for_content(path, location), extension)
      File.write!(output_path, compiled_content)
    end)
  end
end
