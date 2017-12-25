defmodule Poker.CLITest do
  use ExUnit.Case
  # doctest Poker.Score

  alias Poker.{Card, Rank, CLI}

  test "split" do
    assert ["2H 3D 5S 9C KD", "2C 3H 4S 8C AH"] =
            CLI.split("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH")
  end

  test "judge" do
    assert {:ok, card}  = Card.new("AH")
    assert %Rank{winner: :right, category: "C", card: ^card} =
              CLI.judge("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH")
  end

  test "print_judgement - malformed" do
    assert CLI.main_("foo bar") ==
      "Malformed input: 'foo bar'; message: [\"foo bar\"]"
  end

  test "print_judgement - white, high card: ace" do
    assert CLI.main_("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH") ==
      "White wins - high card: Ace"
  end

  test "print_judgement - white, flush" do
    assert CLI.main_("Black: 2H 4S 4C 3D 4H White: 2S 8S AS QS 3S") ==
      "White wins - flush"
  end

  test "print_judgement - black, high card: 9" do
    assert CLI.main_("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH") ==
      "Black wins - high card: 9"
  end

  test "print_judgement - tie " do
    assert CLI.main_("Black: 2H 3D 5S 9C KD White: 2D 3H 5C 9S KH") == "Tie"
  end
end
