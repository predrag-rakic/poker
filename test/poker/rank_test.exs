defmodule Poker.RankTest do
  use ExUnit.Case
  doctest Poker.Card

  alias Poker.{Card, Rank, Category}

  test "compare - high card - tie" do
    assert {:ok, left}  = Category.new("5H JH 7S AC 9H")
    assert {:ok, right} = Category.new("5S JD 7D AS 9C")
    assert Rank.compare(left, right) == %Rank{winner: :tie, category: "C", card: nil}
  end

  test "compare - high card - left - last card" do
    assert {:ok, left}  = Category.new("6H JH 7S AC 9H")
    assert {:ok, right} = Category.new("5S JD 7D AS 9C")
    assert {:ok, card}  = Card.new("6H")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "C", card: card}
  end

  test "compare - high card - left - first card" do
    assert {:ok, left}  = Category.new("6H KH 7S AC 9H")
    assert {:ok, right} = Category.new("7S JD 8D KS TC")
    assert {:ok, card}  = Card.new("AC")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "C", card: card}
  end

  test "compare - pair - left, cat" do
    assert {:ok, left}  = Category.new("6H JH 6S AC 9H")
    assert {:ok, right} = Category.new("5S JD 7D AS 9C")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "2", card: nil}
  end

  test "compare - pair - right, card - pair" do
    assert {:ok, left}  = Category.new("6H KH 6S AC 9H")
    assert {:ok, right} = Category.new("7S JS 7S AS 9C")
    assert {:ok, card}  = Card.new("7S")
    assert  Rank.compare(left, right) == %Rank{winner: :right, category: "2", card: card}
  end

  test "compare - pair - right, card - remaining cards first" do
    assert {:ok, left}  = Category.new("6H JH 6S KC 9H")
    assert {:ok, right} = Category.new("6C QH 6D AS 9C")
    assert {:ok, card}  = Card.new("AS")
    assert  Rank.compare(left, right) == %Rank{winner: :right, category: "2", card: card}
  end

  test "compare - pair - right, card - remaining cards last" do
    assert {:ok, left}  = Category.new("6H QD 6S AC 8H")
    assert {:ok, right} = Category.new("6C QH 6D AS 9C")
    assert {:ok, card}  = Card.new("9C")
    assert  Rank.compare(left, right) == %Rank{winner: :right, category: "2", card: card}
  end

  test "compare - two pairs - left, cat" do
    assert {:ok, left}  = Category.new("6H AH 6S AC 9H")
    assert {:ok, right} = Category.new("5S JD 7D AS 9C")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "P", card: nil}
  end

  test "compare - two pairs - left, card - higher pair" do
    assert {:ok, left}  = Category.new("6H AH 6S AC TH")
    assert {:ok, right} = Category.new("7C KD 7D KS 9C")
    assert {:ok, card}  = Card.new("AH")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "P", card: card}
  end

  test "compare - two pairs - left, card - lower pair" do
    assert {:ok, left}  = Category.new("7H AH 7S AC TH")
    assert {:ok, right} = Category.new("6C AD 6D AS 9C")
    assert {:ok, card}  = Card.new("7H")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "P", card: card}
  end

  test "compare - two pairs - left, card - remaining card" do
    assert {:ok, left}  = Category.new("6H AH 6S AC TH")
    assert {:ok, right} = Category.new("6C AD 6D AS 9C")
    assert {:ok, card}  = Card.new("TH")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "P", card: card}
  end

  test "compare - three of a kind - left, cat" do
    assert {:ok, left}  = Category.new("6H 6C 6S AC TH")
    assert {:ok, right} = Category.new("2C AD 2D AS 9C")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "3", card: nil}
  end

  test "compare - three of a kind - left, card" do
    assert {:ok, left}  = Category.new("6H 6C 6S 3C 5H")
    assert {:ok, right} = Category.new("2C 2H 2D AS 9C")
    assert {:ok, card}  = Card.new("6H")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "3", card: card}
  end

  test "compare - straight - tie" do
    assert {:ok, left}  = Category.new("6H 4C 7S 3H 5H")
    assert {:ok, right} = Category.new("6C 7H 4S 3C 5C")
    assert  Rank.compare(left, right) == %Rank{winner: :tie, category: "S", card: nil}
  end

  test "compare - straight - left, card" do
    assert {:ok, left}  = Category.new("6H 4C 7S 3H 5H")
    assert {:ok, right} = Category.new("6C 2H 4S 3C 5C")
    assert {:ok, card}  = Card.new("7S")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "S", card: card}
  end

  test "compare - flush - left, card - highes" do
    assert {:ok, left}  = Category.new("6H TH 7H 3H 5H")
    assert {:ok, right} = Category.new("9C 2C 7C 3C 5C")
    assert {:ok, card}  = Card.new("TH")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "F", card: card}
  end

  test "compare - flush - left, card - lowest" do
    assert {:ok, left}  = Category.new("9H TH 7H 3H 5H")
    assert {:ok, right} = Category.new("9C TC 7C 2C 5C")
    assert {:ok, card}  = Card.new("3H")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "F", card: card}
  end

  test "compare - full house - left, card" do
    assert {:ok, left}  = Category.new("9C 9H 9S 3C 3H")
    assert {:ok, right} = Category.new("8C 8H 8H 5C 5D")
    assert {:ok, card}  = Card.new("9C")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "H", card: card}
  end

  test "compare - 4 of a kind - left, card" do
    assert {:ok, left}  = Category.new("9C 9H 9S 9D 3H")
    assert {:ok, right} = Category.new("8C 8H 8S 8D 5D")
    assert {:ok, card}  = Card.new("9C")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "4", card: card}
  end

  test "compare - straight flush - left, cat" do
    assert {:ok, left}  = Category.new("7H 6H 4H 3H 5H")
    assert {:ok, right} = Category.new("8C 8H 8S 8D 5D")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "T", card: nil}
  end

  test "compare - straight flush - left, card" do
    assert {:ok, left}  = Category.new("7H 6H 4H 3H 5H")
    assert {:ok, right} = Category.new("2D 6D 4D 3D 5D")
    assert {:ok, card}  = Card.new("7H")
    assert  Rank.compare(left, right) == %Rank{winner: :left, category: "T", card: card}
  end
end
