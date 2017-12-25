defmodule Poker.Rank do
  @moduledoc """
  Compares two categories.
  """

  alias Poker.{Card, Hand, Category}
  alias Poker.SameValueCards, as: SVC

  @enforce_keys [:winner, :category, :card]
  defstruct [:winner, :category, :card]

  @doc """
  Compares two categories.

  Winner contains:  :left, :right or :tie
  """
  def compare(%Category{} = l, %Category{} = r), do:
    compare_(l.category, r.category, l, r)

  def compare_(lcat, rcat, l, r) when lcat == rcat, do:
    on_card(lcat, l.hand, r.hand)

  def compare_(lcat, rcat, l, r) when lcat != rcat do
    if Category.less_than(l, r) do
      different_category(:right, r.category)
    else
      different_category(:left, l.category)
    end
  end

  def on_card(category, lhand, rhand) do
    lcards = get_cards(category, lhand)
    rcards = get_cards(category, rhand)
    {winner, card} = compare_card_lists(lcards, rcards)
    response(winner, category, card)
  end

  def get_cards("T", hand), do: [Hand.highest_card(hand)]
  def get_cards("4", hand) do
    {[[card | _]], _} = SVC.find(hand, 4)
    [card]
  end
  def get_cards("H", hand) do
    {[[card | _]], _} = SVC.find(hand, 3)
    [card]
  end
  def get_cards("F", hand), do: hc_rules(hand)
  def get_cards("S", hand), do: [Hand.highest_card(hand)]
  def get_cards("3", hand) do
    {[[card | _]], _} = SVC.find(hand, 3)
    [card]
  end
  def get_cards("P", hand) do
    {[[c1, _], [c2, _]], [[c3]]} = SVC.find(hand, 2)
    [c1, c2] |> Card.sort() |> Enum.reverse() |> List.insert_at(-1, c3)
  end
  def get_cards("2", hand) do
    {[[c1, _]], remaining} = SVC.find(hand, 2)
    remaining
    |> List.flatten()
    |> Card.sort()
    |> Enum.reverse()
    |> List.insert_at(0, c1)
  end
  def get_cards("C", hand), do: hc_rules(hand)

  def hc_rules(hand), do: hand |> Hand.sort() |> Hand.cards() |> Enum.reverse()

  defp different_category(winner, category), do:
    response(winner, category, nil)

  defp response(winner, category, card) do
    struct!(__MODULE__, winner: winner,  category: category, card: card)
  end

  defp compare_card_lists(lcards, rcards) do
    {lcards, rcards}
    lcards_order = lcards |> Enum.map(&Card.order/1)
    rcards_order = rcards |> Enum.map(&Card.order/1)
    cond do
      lcards_order > rcards_order   -> :left
      lcards_order == rcards_order  -> :tie
      true                          -> :right
    end
    |> card_diff(lcards, rcards)
  end

  defp card_diff(select, l, r), do:
    l
    |> Enum.zip(r)
    |> Enum.find({nil, nil}, fn({l, r}) -> Card.order(l) != Card.order(r) end)
    |> card(select)

  defp card({l, _r},  :left),  do: {:left, l}
  defp card({_l, _r}, :tie),   do: {:tie, nil}
  defp card({_l, r},  :right), do: {:right, r}
end
