defmodule Gameday.Inning do
  defstruct number: 1

  def from_node(node) do
    {num, _} = Gameday.XmlNode.attr(node, 'num')
      |> Integer.parse
    %Gameday.Inning{number: num}
  end
end