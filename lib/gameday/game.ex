defmodule Gameday.Game do
  defstruct innings: [], pitches: []

  @user_agent [ { "User-agent", "Elixir"} ]
  @gameday_url Application.get_env(:gameday, :gameday_url)

  def fetch(year, month, day, gid) do
    game_url(year, month, day, gid)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def game_url(year, month, day, gid) do
    "#{@gameday_url}/components/game/mlb/year_#{year}/month_#{month}/day_#{day}/#{gid}/inning/inning_all.xml"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, parse_game(body)}
  end
  def handle_response({:ok, %HTTPoison.Response{status_code: _, body: body}}), do: { :error, body }
  def handle_response({:error, %HTTPoison.Error{reason: reason}}), do: { :error, reason }

  def parse_game(body) do
    node = body
      |> Gameday.XmlNode.from_string

    innings = node
      |> Gameday.XmlNode.all('/game/inning')

    pitches = node
      |> Gameday.XmlNode.all('/game/inning//atbat/pitch')

    %Gameday.Game{innings: innings, pitches: pitches}
  end

end