defmodule Poker.HandTest do
  use ExUnit.Case
  doctest Poker.Card

  alias Poker.{Card, Hand}

  test "Hand struct exists" do
    struct(Hand)
  end

  test "create hand - valid" do
    {:ok, c} = Card.new("2S")
    assert {:ok, hand} = Hand.new([c, c, c, c, c])
    assert %Hand{} = hand
  end

  test "create hand - invalid" do
    {:ok, c} = Card.new("2S")
    assert {:error, {:invalid, _}} = Hand.new([c, c, c, c, "2S"])
  end

  test "sort cards" do
    {:ok, jack} = Card.new("JH")
    {:ok, four} = Card.new("4S")
    {:ok, ace} = Card.new("AS")
    {:ok, eight} = Card.new("8C")
    {:ok, two} = Card.new("2D")
    {:ok, hand} = Hand.new([jack, four, ace, eight, two])
    {:ok, sorted_hand} = Hand.new([two, four, eight, jack, ace])
    assert sorted_hand = Hand.sort(hand)
  end

  defp card(str), do: Card.new(str) |> elem(1)

end
