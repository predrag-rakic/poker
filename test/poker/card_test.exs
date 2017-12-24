defmodule Poker.CardTest do
  use ExUnit.Case
  doctest Poker.Card

  alias Poker.Card

  test "card create - success" do
    assert {:ok, _card} = Card.new("2S")
  end

  test "card create - not enough characters" do
    assert {:error, {:invalid_format, _card}} = Card.new("2")
  end

  test "card create - too many characters" do
    assert {:error, {:invalid_format, _card}} = Card.new("222")
  end

  test "card create - invalid value" do
    assert {:error, {:invalid_value, _}} = Card.new("1S")
  end

  test "card create - invalid suit" do
    assert {:error, {:invalid_suit, _}} = Card.new("2G")
  end

  test "sort" do
    assert {:ok, c1} = Card.new("KS")
    assert {:ok, c2} = Card.new("TS")
    assert {:ok, c3} = Card.new("2S")
    assert [c3, c2, c1] == Card.sort([c1, c2, c3])
  end

  test "comparison - wrong type" do
    {:ok, l} = Card.new("2S")
    assert_raise(FunctionClauseError, fn -> Card.less_than_equal(l, "2S") end)
  end

  test "comparison - less than" do
    {:ok, l} = Card.new("2S")
    {:ok, r} = Card.new("3S")
    assert Card.less_than_equal(l, r) == true
  end

  test "comparison - equal to" do
    {:ok, l} = Card.new("5S")
    {:ok, r} = Card.new("5S")
    assert Card.less_than_equal(l, r) == true
  end

  test "comparison - grater than" do
    {:ok, l} = Card.new("AS")
    {:ok, r} = Card.new("JS")
    assert Card.less_than_equal(l, r) == false
  end

  test "is_card" do
    refute Card.is_card("AS")
    {:ok, l} = Card.new("AS")
    assert Card.is_card(l)
  end

  test "struct to_string conversion" do
    {:ok, l} = Card.new("AS")
    assert "AS" = to_string(l)
  end
end
