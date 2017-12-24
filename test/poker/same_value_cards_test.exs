defmodule Poker.SameValueCardsTest do
  use ExUnit.Case
  doctest Poker.SameValueCards, import: true

  alias Poker.{Hand}
  alias Poker.SameValueCards, as: SVC


  test "two pairs" do
    assert {:ok, hand} = Hand.new("AC 2D 3H 2C AS")
    assert {[[_, _], [_, _]],[[_]]} = SVC.find(hand, 2)
  end

  test "three of a kind" do
    assert {:ok, hand} = Hand.new("2H 2D 3H 2C AS")
    assert {[[_, _, _]], _} = SVC.find(hand, 3)
  end

  test "three cards with the same value do NOT form a pair" do
    assert {:ok, hand} = Hand.new("2H 2D 3H 2C AS")
    assert {[], _} = SVC.find(hand, 2)
  end

  test "four of a kind" do
    assert {:ok, hand} = Hand.new("2H 2D 2S 2C AS")
    assert {[[_, _, _, _]], [[_]]} = SVC.find(hand, 4)
  end

  test "four cards with the same value do NOT form anything less" do
    assert {:ok, hand} = Hand.new("2H 2D 2S 2C AS")
    assert {[], _} = SVC.find(hand, 2)
    assert {[], _} = SVC.find(hand, 3)
  end

  test "high card" do
    assert {:ok, hand} = Hand.new("5C TH AD 2H 8S")
    assert {_, []} = SVC.find(hand, 1)
  end
end
