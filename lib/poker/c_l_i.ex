defmodule Poker.CLI do
  @moduledoc """
  """

  alias Poker.{Card, Category, Rank}

  def main(input), do: input |> Enum.join(" ") |> main_() |> IO.puts

  def main_(string), do: string |> judge() |> output()

  def judge(input) when is_binary(input) do
    with  [black_input, white_input] <- split(input),
          {:ok, black} <- Category.new(black_input),
          {:ok, white} <- Category.new(white_input),
          {:ok, _} <- validate_cards(black.hand.cards, white.hand.cards),
          %Rank{} = rank <- Rank.compare(black, white)
    do
      rank
    else e ->
      "Malformed input: '#{input}'; message: #{inspect e}"
    end
  end

  def split(input) do
    input
    |> String.split(["Black:", "White:"], trim: true)
    |> Enum.map(&String.trim/1)
  end

  defp output(%Rank{winner: :tie}), do: "Tie"
  defp output(%Rank{winner: :left, category: category, card: card}), do:
    "Black wins - " <> result(category, card)
  defp output(%Rank{winner: :right, category: category, card: card}), do:
    "White wins - " <> result(category, card)
  defp output(message), do: message

  defp result(category, card), do:
    "#{%Category{category: category, hand: ""}}" <> card_value(card)

  defp card_value(nil), do: ""
  defp card_value(%Card{} = card), do: ": #{card}"

  defp validate_cards(l, r), do:
    (l ++ r) |> Enum.uniq() |> length() |> validate_cards_()

  defp validate_cards_(_card_count = 10), do: {:ok, ""}
  defp validate_cards_(_card_count),      do:
    {:error, "Same card(s) appeared more than once? You are cheating!"}
end
