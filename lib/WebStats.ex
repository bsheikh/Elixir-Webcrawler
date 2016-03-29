defmodule WebStats do
  use Application

  def start(_type, _args) do
    IO.puts "Hello world"



    # prevents bad value from returning
    # http://stackoverflow.com/questions/30687781/how-to-run-elixir-application
    Task.start(fn -> :timer.sleep(1000); IO.puts("done sleeping") end)
  end
end
