defmodule Bolt.Compiler do
  def compile(location) do
    File.rm_rf(Bolt.Path.output(location))
    File.mkdir(Bolt.Path.output(location))
    Enum.map(Bolt.File.content_files(location), fn(content_file) -> 
      replace_content_path_with_output_path(content_file, location)
      |> assign_layout
      |> Bolt.Renderer.render
      |> write
    end)
  end

  defp write({path, content}) do
    File.write!(path, content)
  end

  defp replace_content_path_with_output_path({path, content}, location) do
    {Bolt.Path.output_path_from(path, location), content, location}
  end

  defp assign_layout({path, content, location}) do
    {path, content, Bolt.File.layout(location)}
  end
end

defmodule Bolt.Renderer do
  def render({path, content, layout}) do
    {metadata, content_without_metadata} = parse_metadata(content)
    compiled_content = transform(content_without_metadata, [], extension(path))
    {replace_extension(path), transform(layout, [content: compiled_content, item: metadata], :eex)}
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
    String.split(path, ".") |> Enum.reverse |> hd |> String.to_atom
  end

  defp replace_extension(path) do
    remove_extension(path) <> ".html"
  end

  defp remove_extension(path) do
    parts = String.split(path, ".") |> Enum.reverse |> tl |> Enum.reverse
    Enum.join(parts, ".")
  end

  defp parse_metadata(content) do
    [_ | [metadata | content_without_metadata]] = String.split(content, "---\n")
    {yaml_to_dictionary(metadata), Enum.join(content_without_metadata, "---\n")}
  end

  defp yaml_to_dictionary(yaml) do
    YamlElixir.read_from_string(yaml)
    |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
  end
end
