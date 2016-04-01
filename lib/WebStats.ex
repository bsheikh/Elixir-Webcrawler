defmodule WebStats do
  use HTTPoison.Base


  def startOn(url, maxPages \\ 10, maxDepth \\ 3) do
    stringResponce = getContent(url)
    parseContent(stringResponce)
  end

  def getContent(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:error, %HTTPoison.Error{reason: reason}} ->
        nil
    end
  end

  def parseContent(stringtoParse) do
    stringArray = String.split(stringtoParse, "\n")
    for string <- stringArray do
      patternMatch = Regex.run(~r/< ?([A-Za-z]+)/i, string)
      if !is_nil(patternMatch) do
        IO.puts List.last(patternMatch)
      end
    end
  end


  defp printTags() do
  end

end
