defmodule Gameday.Game do
  defstruct innings: [], pitches: []

  @user_agent [ { "User-agent", "Elixir"} ]
  @gameday_url Application.get_env(:gameday, :gameday_url)

  @doc """
  Given a year, month, and day, return a list of game ids (gid) played on
  that day
  """
  def list(year, month, day) do
    day_url(year, month, day)
      |> HTTPoison.get(@user_agent)
      |> handle_response(&parse_list/1)
  end

  @doc """
  Given a game id, return a Gameday.Game struct that contains parsed data
  """
  def fetch(gid) do
    # matches gid_2015_06_09_seamlb_clemlb_1
    [year, month, day] = parse_game_id(gid)
    fetch(year, month, day, gid)
  end
  def fetch(year, month, day, gid) do
    game_url(year, month, day, gid)
      |> HTTPoison.get(@user_agent)
      |> handle_response(&parse_game/1)
  end

  def parse_game_id(gid) do
    [_, year, month, day] = Regex.run(~r/gid_(\d{4})_(\d{2})_(\d{2})_.*/, gid)
    [year, month, day]
  end

  def day_url(year, month, day) do
    "#{@gameday_url}/components/game/mlb/year_#{year}/month_#{month}/day_#{day}/"
  end

  def game_url(year, month, day, gid) do
    "#{day_url(year,month,day)}#{gid}/inning/inning_all.xml"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}, success) do
    {:ok, success.(body)}
  end
  def handle_response({:ok, %HTTPoison.Response{status_code: _, body: body}}, _success), do: { :error, body }
  def handle_response({:error, %HTTPoison.Error{reason: reason}}, _success), do: { :error, reason }

  def parse_game(body) do
    node = body
      |> Gameday.XmlNode.from_string

    innings = node
      |> Gameday.XmlNode.all('/game/inning')
      |> Enum.map &Gameday.Inning.from_node/1

    pitches = node
      |> Gameday.XmlNode.all('/game/inning//atbat/pitch')
      |> Enum.map &Gameday.Pitch.from_node/1

    %Gameday.Game{innings: innings, pitches: pitches}
  end

  def parse_list(body) do
    body
      |> Floki.find("li a")
      |> Floki.attribute("href")
  end

end