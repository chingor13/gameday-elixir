defmodule Gameday.Pitch do
  defstruct speed: 1, strike: false, type: ""

  def from_node(node) do
    {speed, _} = Gameday.XmlNode.attr(node, 'start_speed')
      |> Float.parse
    strike = node
      |> Gameday.XmlNode.attr('type')
    %Gameday.Pitch{ speed: speed, 
                    strike: strike == "S",
                    type: Gameday.XmlNode.attr(node, 'pitch_type')}
  end
end