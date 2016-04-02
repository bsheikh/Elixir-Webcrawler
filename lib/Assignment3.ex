defmodule Assignment3 do

  def startOn(url, maxPages \\ 10, maxDepth \\ 3) do

    globalUrlStatsMap = Map.new

    stringResponce = Assignment3.WebCrawler.getContent(url)
    localUrlStatMap = Assignment3.WebCrawler.parseContent(stringResponce)
    globalUrlStatsMap = mergeLocalMapAndGlobalMap(globalUrlStatsMap,localUrlStatMap)

    globalUrlStatsMap = sortGlobalMap(globalUrlStatsMap) #method should be called last
    IO.inspect globalUrlStatsMap #once sorted, this prints the map
    :done
  end

  defp mergeLocalMapAndGlobalMap(globalMap, localMap) do
    Map.merge(globalMap, localMap, fn _k, v1, v2 ->
      v1 + v2
    end)
  end

  defp sortGlobalMap(globalMap) do
    globalMap
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
      localUrlStatMap
    end

    defp printLocalUrlStatMap(localUrlStatMap) do
      IO.inspect localUrlStatMap, char_lists: :as_lists
    end

  end
end
