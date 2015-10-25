defmodule GameTest do
  use ExUnit.Case
  alias Gameday.Game

  def sample_xml do
    """
    <game atBat="543401" deck="467793" hole="488726" ind="F">
      <inning num="1" away_team="sea" home_team="cle" next="Y">
        <top>
          <atbat num="1" b="0" s="0" o="0" start_tfs="231022" start_tfs_zulu="2015-06-09T23:10:22Z" batter="489149" stand="L" b_height="6-2" pitcher="446372" p_throws="R" des="Logan Morrison singles on a fly ball to left fielder Ryan Raburn. " des_es="Logan Morrison pega sencillo con elevado a jardinero izquierdo Ryan Raburn. " event_num="5" event="Single" event_es="Sencillo" play_guid="555d954b-aa11-43cd-bb88-83c7508705d7" home_team_runs="0" away_team_runs="0">
            <pitch des="In play, no out" des_es="En juego, no out" id="3" type="X" tfs="231057" tfs_zulu="2015-06-09T23:10:57Z" x="142.77" y="194.01" event_num="3" sv_id="150609_191049" play_guid="555d954b-aa11-43cd-bb88-83c7508705d7" start_speed="92.4" end_speed="86.2" sz_top="3.56" sz_bot="1.64" pfx_x="-7.52" pfx_z="7.76" px="-0.676" pz="1.658" x0="-1.731" y0="50.0" z0="5.479" vx0="5.463" vy0="-135.225" vz0="-7.002" ax="-14.12" ay="25.502" az="-17.524" break_y="23.9" break_angle="34.9" break_length="4.9" pitch_type="SI" type_confidence=".934" zone="7" nasty="72" spin_dir="223.944" spin_rate="2182.950" cc="" mt=""/>
            <runner id="489149" start="" end="1B" event="Single" event_num="5"/>
          </atbat>
        </top>
        <bottom>
        </bottom>
      </inning>
      <inning num="2" away_team="sea" home_team="cle" next="N">
      </inning>
    </game>
    """
  end

  test "can fetch and parse data" do
    {:ok, game} = Game.fetch("2015", "06", "09", "gid_2015_06_09_seamlb_clemlb_1")
    assert length(game.innings) == 9
    assert length(game.pitches) == 595
  end

  test "can parse data" do
    game = Game.parse_game(sample_xml)
    assert length(game.innings) == 2
    assert length(game.pitches) == 1
  end

  test "can build url" do
    assert Game.game_url("2015", "06", "09", "gid_2015_06_09_seamlb_clemlb_1") == "http://gd2.mlb.com/components/game/mlb/year_2015/month_06/day_09/gid_2015_06_09_seamlb_clemlb_1/inning/inning_all.xml"
  end
end