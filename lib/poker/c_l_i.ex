defmodule Poker.CLI do
  @moduledoc """
  """

  alias Poker.{Card, Hand, Category, Rank}

  def main(input), do: input |> Enum.join(" ") |> main_()

  def main_(string), do: string |> judge() |> output() |> IO.puts

  def judge(input) when is_binary(input) do
    [black_input, white_input] = split(input)
    with  {:ok, black} <- Category.new(black_input),
          {:ok, white} <- Category.new(white_input),
          %Rank{} = rank <- Rank.compare(black, white),
    do:
      rank |> IO.inspect(label: "Compare")
  end

  def split(input) do
    input
    |> String.split(["Black:", "White:"], trim: true)
    |> Enum.map(&String.trim/1)
  end

  defp output(%Rank{winner: 0}), do: "Tie"
  defp output(%Rank{winner: 1, category: category, card: card}), do:
    "Black wins - " <> result(category, card)
  defp output(%Rank{winner: -1, category: category, card: card}), do:
    "White wins - " <> result(category, card)

  defp result(category, card), do:
    "#{category}" <> card_value(card)

  defp card_value(nil), do: ""
  defp card_value(%Card{value: value} = card), do: ": #{value}"
end
