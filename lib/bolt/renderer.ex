defmodule Bolt.Renderer do
  def render({path, content}) do
    transform(content, [], Bolt.Path.extension(path))
  end

  def render({path, content}, layout) do
    {metadata, content_without_metadata} = parse_metadata(content)
    {_, compiled_content} = transform(content_without_metadata, [], Bolt.Path.extension(path))
    transform(layout, [content: compiled_content, item: metadata], "eex")
  end

  defp transform(content, _, "md") do
    {"html", Earmark.to_html(content)}
  end

  defp transform(content, params, "eex") do
    {"html", EEx.eval_string(content, assigns: params)}
  end

  defp transform(content, _, extension) do
    {extension, content}
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
