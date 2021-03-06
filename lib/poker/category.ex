defmodule Poker.Category do
  @moduledoc """
  Categorise hand
  """

  alias Poker.Hand
  alias Poker.SameValueCards, as: SVC

  @category_names [
    "straight flush", "four of a kind", "full house", "flush",
    "straight", "three of a kind", "two pairs", "pair", "high card"
  ]
  @valid_categories ~w(T 4 H F S 3 P 2 C)

  @enforce_keys [:category, :hand]
  defstruct [:category, :hand]

  @categorize_by_args [
    # same_suit?,
    #       consequtive?,
    #               same_value,
    #                      group_count,
    #                              category,
    {true,  true,   nil,    nil,    "T"},       # Straight Flush
    {nil,   nil,    4,      1,      "4"},       # Four of a kind
    {nil,   nil,    {3, 2}, {1, 1}, "H"},       # Full House
    {true,  false,  nil,    nil,    "F"},       # Flush
    {false, true,   nil,    nil,    "S"},       # Straight
    {nil,   nil,    3,      1,      "3"},       # Three of a kind
    {nil,   nil,    2,      2,      "P"},       # Two pairs
    {nil,   nil,    2,      1,      "2"},       # Pair
    {nil,   nil,    1,      5,      "C"},       # High Card
  ]

  def new(category, %Hand{} = hand) do
    with  true <- category in @valid_categories
    do {:ok, struct!(__MODULE__, category: category, hand: hand)}
    else e -> {:error, e}
    end
  end

  def new(hand_) when is_binary(hand_) do
    with  {:ok, hand} <- Hand.new(hand_),
    do: {:ok, @categorize_by_args |> categorize(hand)}
  end

  def less_than(%__MODULE__{} = l, %__MODULE__{} = r), do: order(l) < order(r)

  def order(%__MODULE__{} = category), do:
    @valid_categories
    |> Enum.reverse()
    |> Enum.find_index(fn(v) -> v == category.category end)

  def get_name(%__MODULE__{} = category), do:
    @category_names |> Enum.reverse() |> Enum.at(order(category))

  defp categorize([args | tail], hand) do
    hand |> by(args) |> category_response(tail, hand)
  end

  defp by(%Hand{} = hand, {true, true, nil, nil, category}) do
    with  true <- Hand.same_suit?(hand),
          true <- Hand.consequtive_values?(hand)
    do rank_response(hand, category)
    else _ -> nil
    end
  end

  defp by(%Hand{} = hand, {same_suit?, consequtive?, nil, nil, category}) do
    with  ^same_suit?   <- Hand.same_suit?(hand),
          ^consequtive? <- Hand.consequtive_values?(hand)
    do rank_response(hand, category)
    else _ -> nil
    end
  end

  defp by(%Hand{} = hand, {nil, nil, {3, 2}, {1, 1}, category}) do
    with  {[[_, _, _]], [[_, _]]} <- SVC.find(hand, 3)
    do rank_response(hand, category)
    else _ -> nil
    end
  end

  defp by(%Hand{} = hand, {nil, nil, same_value, group_count, category}) do
    hand
    |> SVC.find(same_value)
    |> case do
      # Two pairs
      {pairs, _} when group_count == 2 and length(pairs) == 2 ->
        rank_response(hand, category)
      # High Card
      {cards, _} when group_count == 5 and length(cards) == 5 ->
        rank_response(hand, category)
      # All other
      {[_single_group], _remaining} when group_count == 1 ->
        rank_response(hand, category)
      # match failed
      {_, _} -> nil
    end
  end

  defp category_response(nil,  tail,  hand),  do: categorize(tail, hand)
  defp category_response(resp, _tail, _hand), do: resp

  defp rank_response(hand, category), do:
    category |> new(hand) |> elem(1)
end

defimpl String.Chars, for: Poker.Category do
  @moduledoc "Print Category in required format"

  alias Poker.Category

  def to_string(category), do: "#{Category.get_name(category)}"
end
