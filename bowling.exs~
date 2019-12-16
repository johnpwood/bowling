defmodule Bowling do
  defstruct score: 0,
            frame: 0,
            start_of_frame?: true,
            this_bonus: 1,
            next_bonus: 1,
            last_roll: 0,
            game_over?: false

  def start do
    %Bowling{}
  end

  def roll(_game, pins) when pins < 0 do
    {:error, "Negative roll is invalid"}
  end

  def roll(_game, pins) when pins > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(%{last_roll: r, start_of_frame?: false}, pins) when r + pins > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(game = %{frame: f}, pins) when f < 10 do
    type =
      cond do
        pins + game.last_roll == 10 and not game.start_of_frame? -> :spare
        pins == 10 -> :strike
        true -> :nothing_special
      end

    %{
      score: game.score + pins * game.this_bonus,
      frame:
        cond do
          game.start_of_frame? and pins < 10 -> game.frame
          true -> game.frame + 1
        end,
      start_of_frame?: pins == 10 or not game.start_of_frame?,
      this_bonus:
        game.next_bonus +
          case type do
            :strike -> 1
            :spare -> 1
            :nothing_special -> 0
          end,
      next_bonus:
        1 +
          case type do
            :strike -> 1
            :spare -> 0
            :nothing_special -> 0
          end,
      last_roll: pins,
      game_over?: game.frame == 9 and type == :nothing_special
    }
  end

  def roll(%{game_over?: true}, _pins) do
    {:error, "Cannot roll after game is over"}
  end

  def roll(game, pins) do
    %{
      score: game.score + pins * (game.this_bonus - 1),
      this_bonus: game.next_bonus,
      next_bonus: 1,
      start_of_frame?: pins == 10,
      last_roll: pins,
      game_over?: game.next_bonus == 1
    }
  end

  def score(%{game_over?: false}) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  def score(game) do
    game.score
  end
end
