defmodule Hanoi do
  @moduledoc """
   The Tower of Hanoi data structure and operations
  """
  defstruct started: false,
            ended: false,
            duration: 0,
            picked: nil,
            num_pieces: 4,
            num_moves: 0,
            tower_a: [],
            tower_b: [],
            tower_c: [],
            display_a: [],
            display_b: [],
            display_c: []

  @max_pieces 8
  def max_pieces(), do: @max_pieces

  @doc """
  Create a new game with `num_pieces` blocks.  You can provide an existing
  game and grab it's number of pieces too.

  ## Examples

     iex> Hanoi.new_game()
     %Hanoi{tower_a: [4,3,2,1], display_a: [{4, :down}, {3, :down}, {2, :down}, {1, :down}]}

     iex> Hanoi.new_game(5)
     %Hanoi{num_pieces: 5, tower_a: [5,4,3,2,1], display_a: [{5, :down}, {4, :down}, {3, :down}, {2, :down}, {1, :down}]}

     iex> Hanoi.new_game(5) |> Hanoi.new_game()
     %Hanoi{num_pieces: 5, tower_a: [5,4,3,2,1], display_a: [{5, :down}, {4, :down}, {3, :down}, {2, :down}, {1, :down}]}
  """
  def new_game(), do: new_game(4)
  def new_game(%Hanoi{num_pieces: num_pieces}), do: new_game(num_pieces)
  def new_game(num_pieces) when num_pieces < 1, do: new_game(1)
  def new_game(num_pieces) when num_pieces > @max_pieces, do: new_game(@max_pieces)

  def new_game(num_pieces) do
    %Hanoi{
      num_pieces: num_pieces,
      tower_a: num_pieces..1 |> Enum.into([])
    }
    |> display()
  end

  @doc """
  Add another piece to the game, this will restart the game.
  The maximum number of pieces (right now) is 8

  ## Examples

     iex> Hanoi.new_game(3) |> Hanoi.inc()
     %Hanoi{tower_a: [4,3,2,1], display_a: [{4, :down}, {3, :down}, {2, :down}, {1, :down}]}

     iex> Hanoi.new_game(8) |> Hanoi.inc()
     Hanoi.new_game(8)
  """
  def inc(game), do: new_game(game.num_pieces + 1)

  @doc """
  Remove a piece from the game, this will restart the game.
  The minimum numnber of pieces is 1

  ## Examples

     iex> Hanoi.new_game(5) |> Hanoi.dec()
     %Hanoi{tower_a: [4,3,2,1], display_a: [{4, :down}, {3, :down}, {2, :down}, {1, :down}]}

     iex> Hanoi.new_game(1) |> Hanoi.dec()
     %Hanoi{num_pieces: 1, tower_a: [1], display_a: [{1, :down}]}
  """
  def dec(game), do: new_game(game.num_pieces - 1)

  @doc """
  When you are ready, start the game

  ## Examples

     iex> Hanoi.new_game() |> Hanoi.start_game() |> Hanoi.started?()
     true
  """
  def start_game(game), do: %{game | started: now()}

  @doc """
  Did you give up?  Ok, then restart the game.
  This will create a new game of the same number of blocks and mark it as started

  ## Examples

     iex> Hanoi.new_game(2) |> Hanoi.start_game() |> Hanoi.restart_game() |> Map.fetch!(:num_pieces)
     2

     iex> Hanoi.new_game(2) |> Hanoi.start_game() |> Hanoi.restart_game() |> Hanoi.started?()
     true
  """
  def restart_game(game), do: new_game(game.num_pieces) |> start_game()

  @doc """
  Has the game started?  Check if the started is false, if not then it is started

  ## Examples

     iex> Hanoi.new_game(2) |> Hanoi.started?()
     false

     iex> Hanoi.new_game(2) |> Hanoi.start_game() |> Hanoi.started?()
     true
  """
  def started?(%Hanoi{started: false}), do: false
  def started?(%Hanoi{started: _}), do: true

  @doc """
  Has the game ended?  Check if the ended is false, if not then it has neded

  ## Examples

     iex> Hanoi.new_game(2) |> Hanoi.ended?()
     false

     iex> Hanoi.ended?(%Hanoi{ended: 1234})
     true
  """
  def ended?(%Hanoi{ended: false}), do: false
  def ended?(%Hanoi{ended: _}), do: true

  @doc """
  Pick a piece.

  ## Examples

     iex> Hanoi.new_game(2) |> Hanoi.pick(:tower_b)
     %Hanoi{num_pieces: 2, tower_a: [2,1], display_a: [{2, :down}, {1, :down}]}

     iex> Hanoi.new_game(2) |> Hanoi.pick(:tower_a)
     %Hanoi{num_pieces: 2, picked: {:tower_a, 2}, tower_a: [1], display_a: [{2, :up}, {1, :down}]}

     iex> Hanoi.new_game(2) |> Hanoi.pick(:tower_a) |> Hanoi.pick(:tower_a)
     %Hanoi{num_pieces: 2, picked: nil, tower_a: [2, 1], display_a: [{2, :down}, {1, :down}]}

     iex> Hanoi.new_game(2) |> Hanoi.pick(:tower_a) |> Hanoi.pick(:tower_b)
     %Hanoi{num_pieces: 2, picked: nil, num_moves: 1, tower_a: [1], tower_b: [2], display_a: [{1, :down}], display_b: [{2, :down}]}

     iex> %Hanoi{picked: {:tower_a, 1}, tower_a: [], tower_b: [2]} |> Hanoi.pick(:tower_b)
     %Hanoi{picked: {:tower_a, 1}, tower_a: [], tower_b: [2], display_a: [{1, :up}], display_b: [{2, :down}]}

     iex> %Hanoi{picked: {:tower_a, 2}, tower_a: [], tower_c: []} |> Hanoi.ended?()
     false

     iex> %Hanoi{picked: {:tower_a, 2}, tower_a: [], tower_c: [1]} |> Hanoi.pick(:tower_c) |> Hanoi.ended?()
     true
  """
  def pick(game, tower) do
    game
    |> _pick(tower, Map.fetch!(game, tower))
    |> display()
  end

  defp _pick(%Hanoi{picked: nil} = game, _tower, []), do: game

  defp _pick(%Hanoi{picked: nil} = game, tower, [h | t]) do
    game
    |> Map.put(:picked, {tower, h})
    |> Map.put(tower, t)
  end

  defp _pick(%Hanoi{picked: {tower, n}} = game, tower, pegs) do
    game
    |> Map.put(:picked, nil)
    |> Map.put(tower, [n | pegs])
  end

  defp _pick(%Hanoi{picked: {_, n}} = game, _tower, [m | _t]) when m > n, do: game

  defp _pick(%Hanoi{picked: {_, n}} = game, tower, pegs) do
    game
    |> Map.put(:picked, nil)
    |> Map.update!(:num_moves, &(&1 + 1))
    |> Map.put(tower, [n | pegs])
  end

  @doc """
  Update the game's display.

  ## Examples

     iex> %Hanoi{picked: {:tower_a, 1}, tower_a: [], tower_b: [2]} |> Hanoi.display()
     %Hanoi{picked: {:tower_a, 1}, tower_a: [], tower_b: [2], display_a: [{1, :up}], display_b: [{2, :down}]}
  """
  def display(game) do
    game
    |> update_towers()
    |> update_won()
    |> update_duration()
  end

  defp display_tower(%Hanoi{picked: {tower, n}} = game, tower) do
    [{n, :up}] ++ down_pegs(game, tower)
  end

  defp display_tower(game, tower) do
    down_pegs(game, tower)
  end

  defp down_pegs(game, tower) do
    game
    |> Map.fetch!(tower)
    |> Enum.map(fn n -> {n, :down} end)
  end

  defp update_towers(game) do
    %{
      game
      | display_a: display_tower(game, :tower_a),
        display_b: display_tower(game, :tower_b),
        display_c: display_tower(game, :tower_c)
    }
  end

  defp update_won(%Hanoi{ended: false, picked: nil, tower_a: [], tower_b: []} = game) do
    %{game | ended: now()}
  end

  defp update_won(game), do: game

  defp update_duration(%Hanoi{started: false} = game), do: %{game | duration: 0}

  defp update_duration(%Hanoi{started: s, ended: false} = game) do
    %{game | duration: duration(s, now())}
  end

  defp update_duration(%Hanoi{started: s, ended: e} = game) do
    %{game | duration: duration(s, e)}
  end

  defp now(), do: :os.system_time(:millisecond)

  defp duration(started, ended), do: ((ended - started) / 1000) |> round()
end
