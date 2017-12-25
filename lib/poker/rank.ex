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

  Returns:
    1 if left is higher
    -1 if right is higher
    0 if they are equal
  """
  def compare(%Category{} = l, %Category{} = r), do:
    compare_(l.category, r.category, l, r)

  def compare_(lcat, rcat, l, r) when lcat == rcat, do:
    on_card(lcat, l.hand, r.hand)

  def compare_(lcat, rcat, l, r) when lcat != rcat do
    if Category.less_than(l, r) do
      different_category(-1, r.category)
    else
      different_category(1, l.category)
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
      lcards_order > rcards_order ->
        {1, card_diff(lcards, rcards, :left)}
      lcards_order == rcards_order  ->   {0, nil}
      true              ->   {-1, card_diff(lcards, rcards, :right)}
    end
  end

  defp card_diff(l, r, select), do:
    l
    |> Enum.zip(r)
    |> Enum.find(fn({l, r}) -> Card.order(l) != Card.order(r) end)
    |> card(select)

  defp card({l, _r}, :left),  do: l
  defp card({_l, r}, :right), do: r
end
