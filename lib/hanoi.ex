defmodule Hanoi do
  @moduledoc """
   The Tower of Hanoi data structure and operations
  """
  defstruct started: false, num_pieces: 4, tower_a: [], tower_b: [], tower_c: []

  @max_pieces 8
  def max_pieces(), do: @max_pieces

  @doc """
  Create a new game with `num_pieces` blocks

  ## Examples

     iex> Hanoi.new_game()
     %Hanoi{tower_a: [4,3,2,1]}

     iex> Hanoi.new_game(5)
     %Hanoi{num_pieces: 5, tower_a: [5,4,3,2,1]}
  """
  def new_game(), do: new_game(4)
  def new_game(num_pieces) when num_pieces < 1, do: new_game(1)
  def new_game(num_pieces) when num_pieces > @max_pieces, do: new_game(@max_pieces)

  def new_game(num_pieces) do
    %Hanoi{
      num_pieces: num_pieces,
      tower_a: num_pieces..1 |> Enum.into([])
    }
  end

  @doc """
  Add another piece to the game, this will restart the game.
  The maximum number of pieces (right now) is 8

  ## Examples

     iex> Hanoi.new_game(3) |> Hanoi.inc()
     %Hanoi{tower_a: [4,3,2,1]}

     iex> Hanoi.new_game(8) |> Hanoi.inc()
     Hanoi.new_game(8)
  """
  def inc(game), do: new_game(game.num_pieces + 1)

  @doc """
  Remove a piece from the game, this will restart the game.
  The minimum numnber of pieces is 1

  ## Examples

     iex> Hanoi.new_game(5) |> Hanoi.dec()
     %Hanoi{tower_a: [4,3,2,1]}

     iex> Hanoi.new_game(1) |> Hanoi.dec()
     %Hanoi{num_pieces: 1, tower_a: [1]}
  """
  def dec(game), do: new_game(game.num_pieces - 1)

  @doc """
  When you are ready, start the game

  ## Examples

     iex> Hanoi.new_game() |> Hanoi.start_game() |> Map.fetch!(:started)
     true
  """
  def start_game(game), do: %{game | started: true}

  @doc """
  Did you give up?  Ok, then restart the game.
  This will create a new game of the same number of blocks and mark it as started

  ## Examples

     iex> Hanoi.new_game(2) |> Hanoi.start_game() |> Hanoi.restart_game()
     %Hanoi{started: true, num_pieces: 2, tower_a: [2,1]}

  """
  def restart_game(game), do: new_game(game.num_pieces) |> start_game()
end
