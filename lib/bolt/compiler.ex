defmodule Bolt.Compiler do
  def compile(location) do
    File.rm_rf(Bolt.Path.output(location))
    File.mkdir(Bolt.Path.output(location))

    compile_content(location)
    compile_assets(location)
  end

  defp compile_assets(location) do
    Enum.map(Bolt.File.asset_files(location), fn({path, content}) ->
      {extension, compiled_content} = Bolt.Renderer.render({path, content})
      File.write!(Bolt.Path.output_for_assets(path, extension, location), compiled_content)
    end)
  end

  defp compile_content(location) do
    Enum.map(Bolt.File.content_files(location), fn({path, content}) ->
      {extension, compiled_content} = Bolt.Renderer.render({path, content}, Bolt.File.layout(location))
      File.write!(Bolt.Path.output_for_content(path, extension, location), compiled_content)
    end)
  end
end
