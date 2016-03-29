defmodule Assignment3 do
  use HTTPoison.Base

  def startOn(url, maxPages \\ 10, maxDepth \\ 3) do


    case HTTPoison.get() do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end

  end

  def process_url(url), do: "http://" <> url

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end
