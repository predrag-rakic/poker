defmodule Poker.CategoryTest do
  use ExUnit.Case
  doctest Poker.Category

  alias Poker.{Hand, Category}

  test "new - struct - success" do
    assert {:ok, hand} = Hand.new("5H 4H 7H 6H 8H")
    assert {:ok, %Category{category: "T", hand: ^hand}} = Category.new("T", hand)
  end

  test "new - struct - fail" do
    assert {:ok, hand} = Hand.new("5H 4H 7H 6H 8H")
    assert {:error, _} = Category.new("Z", hand)
  end

  test "strait flush" do
    assert {:ok, %Category{category: "T"}} = Category.new(strait_flush())
  end

  test "four of a kind" do
    assert {:ok, %Category{category: "4"}} = Category.new(four_of_a_kind())
  end

  test "full house" do
    assert {:ok, %Category{category: "H"}} = Category.new(full_house())
  end

  test "flush" do
    assert {:ok, %Category{category: "F"}} = Category.new(flush())
  end

  test "strait" do
    assert {:ok, %Category{category: "S"}} = Category.new(straight())
  end

  test "three of a kind" do
    assert {:ok, %Category{category: "3"}} = Category.new(three_of_a_kind())
  end

  test "two pairs" do
    assert {:ok, %Category{category: "P"}} = Category.new(two_pairs())
  end

  test "pair" do
    assert {:ok, %Category{category: "2"}} = Category.new(pair())
  end

  test "high card" do
    assert {:ok, %Category{category: "C"}} = Category.new(high_card())
  end

  defp strait_flush, do:      "5H 4H 7H 6H 8H"
  defp four_of_a_kind, do:    "5C 5D 5S 6H 5H"
  defp full_house, do:        "5C 5D 6S 6H 6C"
  defp flush, do:             "JH 4H 7H 6H 8H"
  defp straight, do:          "5C 4H 7D 6H 8H"
  defp three_of_a_kind, do:   "5C 5H 5D 6H 8H"
  defp two_pairs, do:         "5C 5H 6D 6H 8H"
  defp pair, do:              "5C 5H AD 6H 8H"
  defp high_card, do:         "6C QD AD 2H 8S"
end
