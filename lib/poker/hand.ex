defmodule Poker.Hand do
  @moduledoc """
  Five cards in a poker hand
  """

  alias Poker.Card

  @enforce_keys [:cards]
  defstruct [:cards]

  @doc """
  Create new hand

      iex> new("2S 2S 2S 2S 2S")
      {:ok,
            %Poker.Hand{cards: [%Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"}]}}
  """
  def new(cards) when is_binary(cards) do
    cards
    |> String.split()
    |> Enum.map(fn(c) -> Card.new(c) |> elem(1) end)
    |> new()
  end

  @doc """
  Create new hand

      iex> {:ok, c} = Poker.Card.new("2S")
      iex> new([c, c, c, c, c])
      {:ok,
            %Poker.Hand{cards: [%Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"},
              %Poker.Card{suit: "S", value: "2"}]}}
  """
  def new(cards) when is_list(cards) and length(cards) == 5 do
    with  {:ok, _} <- validate_cards(cards),
    do: {:ok, create_hand!(cards)}
  end

  def new(cards), do: {:error, {:malformed_request, cards}}

  @doc """
  Return new Hand with cards sorted
  """
  def sort(%__MODULE__{} = hand) do
    hand.cards
    |> Enum.sort(&Card.less_than_equal/2)
    |> create_hand!()
  end

  @doc """
  Checkis if all cards in hand are of the same suit
  """
  def same_suit?(%__MODULE__{} = hand) do
    suit = hand.cards |> hd() |> Card.suit()
    hand.cards |> tl() |> Enum.all?(fn(card) -> Card.suit(card) == suit end)
  end

  @doc """
  Check if card values in the hand are consequtive
  """
  def consequtive_values?(%__MODULE__{} = hand), do:
    consequtive_values(hand) != nil

  def cards(%__MODULE__{} = hand), do: hand.cards

  defp consequtive_values(hand), do:
    hand
    |> sort()
    |> cards()
    |> Enum.map(&Card.order/1)
    # Reduce receives list of sorted integers.
    # If all integers are consequtive than value in the accumulator
    # incremented by 1 equals current elem value.
    # In that case reduce returns integer.
    # If list is not cosequtive reduce returns nil.
    |> Enum.reduce(&consequtive_integers?/2)

  defp consequtive_integers?(_, nil), do: nil
  defp consequtive_integers?(x, acc) when acc+1 == x, do: x
  defp consequtive_integers?(_, _), do: nil

  defp create_hand!(cards), do: struct!(__MODULE__, cards: cards)

  defp validate_cards(cards), do:
    Enum.all?(cards, &Card.is_card(&1)) |> validate_cards_(cards)

  defp validate_cards_(true,  cards), do: {:ok, cards}
  defp validate_cards_(false, cards), do: {:error, {:invalid, cards}}
end
