defmodule Bowling do
  """
  The Bowling module contains functions to validate and score a bowling game

  usage in the test looks like:

  rolls = a list of integers representing number of pins knocked down
  game = Enum.reduce(rolls, Bowling.start(), fn(roll, g) -> Bowling.roll(g, roll) end)
  then calls
  Bowling.score(game)
  to read the score (should only work at the end of the game
  and return an error tuple if the game is not finished.)

  """

  def start do
    %{
      score: 0,
      frame: 1,
      last_roll: 0,
      second_roll_of_frame?: false,
      current_bonus: 1,
      next_bonus: 1,
      game_over?: false
    }
  end

  def roll(g, pins) do
    case(e = error_check(g, pins)) do
      {:error, _} -> e
      _ -> update_game(g, pins)
    end
  end

  defp update_game(g = %{frame: f}, pins) when f < 11 do
    type =
      cond do
        pins + g.last_roll == 10 and g.second_roll_of_frame? -> :spare
        pins == 10 -> :strike
        true -> :nothing_special
      end

    %{
      score: g.score + g.current_bonus * pins,
      frame:
        cond do
          pins < 10 and not g.second_roll_of_frame? -> g.frame
          true -> g.frame + 1
        end,
      second_roll_of_frame?: pins < 10 and not g.second_roll_of_frame?,
      current_bonus:
        g.next_bonus +
          case type do
            :strike -> 1
            :spare -> 1
            _ -> 0
          end,
      next_bonus:
        1 +
          case type do
            :strike -> 1
            _ -> 0
          end,
      last_roll: pins,
      game_over?: g.frame == 10 and type == :nothing_special and g.second_roll_of_frame?
    }
  end

  defp update_game(g, pins) do
    %{
      score: g.score + pins * (g.current_bonus - 1),
      current_bonus: g.next_bonus,
      next_bonus: 1,
      second_roll_of_frame?: pins < 10,
      last_roll: pins,
      game_over?: g.next_bonus == 1
    }
  end

  defp error_check(g, pins) do
    # IO.inspect(g)

    cond do
      pins < 0 ->
        {:error, "Negative roll is invalid"}

      pins > 10 ->
        {:error, "Pin count exceeds pins on the lane"}

      g.second_roll_of_frame? and g.last_roll + pins > 10 ->
        {:error, "Pin count exceeds pins on the lane"}

      g.game_over? ->
        {:error, "Cannot roll after game is over"}

      true ->
        :no_error
    end
  end

  def score(%{game_over?: false}) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  def score(g) do
    g.score
  end
end
