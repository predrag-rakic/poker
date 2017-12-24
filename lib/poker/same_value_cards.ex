defmodule Poker.SameValueCards do
  @moduledoc """
  Finds groups of cards with the same value.

  Returns 2 element tuple.
  First element is list, containing lists of matching elements grouped by count.
  Second element is list, containing list of not matching elements
  also grouped by count.

  Note: Looks for exacly what is asked.
  Example: hand with 3 cards with the same value won't be reckognised as a pair.
  """

  alias Poker.{Card, Hand}

  @doc """
      iex> {:ok, hand} = Poker.Hand.new("AC JD AH 2C AS")
      iex> find(hand, 2)
      { [],
      [[%Poker.Card{suit: "C", value: "2"}],
       [%Poker.Card{suit: "D", value: "J"}],
       [%Poker.Card{suit: "C", value: "A"},
        %Poker.Card{suit: "H", value: "A"},
        %Poker.Card{suit: "S", value: "A"}]]}

      iex> {:ok, hand} = Poker.Hand.new("AC 2D 3H 2C KS")
      iex> find(hand, 2)
      { [[%Poker.Card{suit: "D", value: "2"},
              %Poker.Card{suit: "C", value: "2"}]],
        [[%Poker.Card{suit: "H", value: "3"}],
         [%Poker.Card{suit: "S", value: "K"}],
         [%Poker.Card{suit: "C", value: "A"}]]}
  """
  def find(%Hand{} = hand, count) when is_integer(count) and count >= 1 do
    hand
    |> Hand.sort()
    |> Hand.cards()
    |> Enum.chunk_by(&Card.order/1)
    |> Enum.split_with(fn(chunk) -> length(chunk) == count end)
  end
end
