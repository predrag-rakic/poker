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
end
