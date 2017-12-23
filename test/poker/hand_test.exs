defmodule Poker.HandTest do
  use ExUnit.Case
  doctest Poker.Hand, import: true

  alias Poker.{Card, Hand}

  test "Hand struct exists" do
    struct(Hand)
  end

  test "create hand, string - success" do
    hand =
      ~w(5H JH 7S AC 9H)
      |> Enum.map(fn(c) -> {:ok, card} = Card.new(c); card end)
      |> Hand.new()
    assert hand == Hand.new("5H JH 7S AC 9H")
  end

  test "create hand, string - failure" do
    assert {:error, {:malformed_request, _}} = Hand.new("5H JH 7S AC 9H 2S")
    assert {:error, {:malformed_request, _}} = Hand.new("5H JH 7S AC ")
    assert {:error, _} = Hand.new("5H JH 7S AC 9h")
  end

  test "create hand, cards - success" do
    {:ok, c} = Card.new("2S")
    assert {:ok, hand} = Hand.new([c, c, c, c, c])
    assert %Hand{} = hand
  end

  test "create hand, cards - invalid" do
    {:ok, c} = Card.new("2S")
    assert {:error, {:invalid, _}} = Hand.new([c, c, c, c, "2S"])
  end

  test "sort cards" do
    assert {:ok, hand}          =  Hand.new("JH 4S AS 8C 2D")
    assert {:ok, sorted_hand}   =  Hand.new("2D 4S 8C JH AS")
    assert sorted_hand          == Hand.sort(hand)
  end

  test "same suit? - true" do
    assert {:ok, hand} = Hand.new("JH 4H AH 8H 2H")
    assert Hand.same_suit?(hand)
  end

  test "same suit? - false" do
    assert {:ok, hand} = Hand.new("JS 4H AH 8H 2H")
    refute Hand.same_suit?(hand)
  end

  test "consequtive values" do
    assert {:ok, hand} = Hand.new("5C 6D 7H 8S 9H")
    assert Hand.consequtive_values?(hand)
    assert {:ok, hand} = Hand.new("9S 6H 7H 8C 5D")
    assert Hand.consequtive_values?(hand)
    assert {:ok, hand} = Hand.new("9S 6C 7H 8S TH")
    assert Hand.consequtive_values?(hand)
    assert {:ok, hand} = Hand.new("9S JC 7H 8S TH")
    assert Hand.consequtive_values?(hand)
  end
end
