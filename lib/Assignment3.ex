defmodule Assignment3 do


  def startOn(url, maxPages \\ 10, maxDepth \\ 3) do
    stringResponce = Assignment3.WebCrawler.getContent(url)
    Assignment3.WebCrawler.parseContent(stringResponce)
  end



  defmodule WebCrawler do
    use HTTPoison.Base

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

    defp incrementLocalUrlStats(pattern) do
      if Map.has_key?(localUrlsWithStats, pattern) do

      else
        Map.put(localUrlsWithStats, pattern, 1)
      end
    end

    defp incrementGlobalUrlStats(pattern) do
    end

    defp printLocalUrlStats do
    end

  end
end
