defmodule Poker.Card do
  @moduledoc """
  Single card from 52 cards deck
  """

  @valid_values ~w(2 3 4 5 6 7 8 9 T J Q K A)
  @valid_suits  ~w(C D H S)

  @enforce_keys [:value, :suit]
  defstruct [:value, :suit]

  @doc ~S"""
  Create new card.

      iex> Poker.Card.new("6H")
      {:ok, %Poker.Card{suit: "H", value: "6"}}
  """
  def new(<<value::bytes-size(1)>> <> <<suit::bytes-size(1)>>) do
    with  {:ok, _} <- validate_value(value),
          {:ok, _} <- validate_suit(suit),
    do: {:ok, struct(__MODULE__, value: value, suit: suit)}
  end
  def new(input), do: {:error, {:invalid_format, input}}

  @doc """
  Compare two cards.

      iex> {:ok, l} = Poker.Card.new("4S")
      iex> {:ok, r} = Poker.Card.new("QS")
      iex> Poker.Card.less_than_equal(l, r)
      true

  """
  def less_than_equal(%__MODULE__{} = l, %__MODULE__{} = r), do:
    order(l) <= order(r)

  def is_card(card) when is_map(card), do:
    Map.get(card, :__struct__) == Poker.Card
  def is_card(_card), do: false

  defp order(%__MODULE__{} = card), do:
    @valid_values |> Enum.find_index(fn(value) -> value == card.value end)

  defp validate_value(value)  when value in @valid_values, do: {:ok, value}
  defp validate_value(value), do: {:error, {:invalid_value, value}}

  defp validate_suit(suit)    when suit  in @valid_suits,  do: {:ok, suit}
  defp validate_suit(suit),   do: {:error, {:invalid_suit, suit}}
end

defimpl String.Chars, for: Poker.Card do
  @moduledoc "Print card in required format"

  def to_string(card), do: "#{card.value}#{card.suit}"
end
