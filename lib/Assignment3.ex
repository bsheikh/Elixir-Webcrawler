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

    def fill_localUrlsWithStats([], localUrlStatBuilder) do
      localUrlStatBuilder
    end

    def fill_localUrlsWithStats([head|tail], localUrlStatBuilder) do
      patternMatch = Regex.run(~r/< ?([A-Za-z]+)/i, head)
      if !is_nil(patternMatch) do
        if Map.has_key?(localUrlStatBuilder, List.last(patternMatch)) do
          currentValue = Map.get(localUrlStatBuilder, List.last(patternMatch))
          localUrlStatBuilder = Map.put(localUrlStatBuilder, List.last(patternMatch), currentValue+1)
        else
          localUrlStatBuilder = Map.put(localUrlStatBuilder, List.last(patternMatch), 1)
        end
        if List.last(patternMatch) === "a" do
          aTagPatternMatch = Regex.run(~r/href=\"((http|https):[^ ]+)\"/i, head)
          if !is_nil(aTagPatternMatch) do
            IO.puts "Link Found"
            IO.puts aTagPatternMatch
            # TODO: use aTagPatternMatch to do multi-threading
            #       aTagPatternMatch contains the link
          end
        end
      end
      fill_localUrlsWithStats(tail, localUrlStatBuilder)
    end

    def parseContent(stringtoParse) do
      localUrlStatMap = Map.new
      stringArray = String.split(stringtoParse, "\n")
      localUrlStatMap = fill_localUrlsWithStats(stringArray, Map.new)
      printLocalUrlStatMap(localUrlStatMap)
      :ok
    end

    defp printLocalUrlStatMap(localUrlStatMap) do
      IO.inspect localUrlStatMap, char_lists: :as_lists
    end

  end
end
