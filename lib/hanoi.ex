defmodule Hanoi do
  @moduledoc """
   The Tower of Hanoi data structure and operations
  """
  defstruct num_pieces: 4, tower_a: [], tower_b: [], tower_c: []

  @doc """
  Create a new game with `num_pieces` blocks

  ## Examples

     iex> Hanoi.new_game()
     %Hanoi{tower_a: [4,3,2,1]}

     iex> Hanoi.new_game(5)
     %Hanoi{num_pieces: 5, tower_a: [5,4,3,2,1]}
  """
  def new_game(num_pieces \\ 4) do
    %Hanoi{
      num_pieces: num_pieces,
      tower_a: num_pieces..1 |> Enum.into([])
    }
  end
end
