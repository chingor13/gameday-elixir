defmodule Gameday.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to the 
  various functions that pull gameday data
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h:    :help])

    case parse do
    { [help: true], _, _ }
      -> :help

    _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: gameday <gameday_stuff>
    """
    System.halt(0)
  end

end