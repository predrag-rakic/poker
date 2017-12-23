defmodule Poker.Hand do
  @moduledoc """
  Five cards in a poker hand
  """

  alias Poker.Card

  @enforce_keys [:cards]
  defstruct [:cards]

  @doc """
  Create new hand

      iex> {:ok, c} = Card.new("2S")
      iex> Hand.new([c, c, c, c, c])
      %Poker.Hand{c, c, c, c, c}
  """
  def new(cards) when is_list(cards) and length(cards) == 5 do
    with  {:ok, _} <- validate_cards(cards),
    do: {:ok, create_hand!(cards)}
  end

  @doc """
  Return new Hand with cards sorted
  """
  def sort(%__MODULE__{} = hand) do
    hand.cards
    |> Enum.sort(&Card.less_than_equal/2)
    |> create_hand!()
  end

  defp create_hand!(cards), do: struct!(__MODULE__, cards: cards)

  defp validate_cards(cards), do:
    Enum.all?(cards, &Card.is_card(&1)) |> validate_cards_(cards)

  defp validate_cards_(true,  cards), do: {:ok, cards}
  defp validate_cards_(false, cards), do: {:error, {:invalid, cards}}
end
