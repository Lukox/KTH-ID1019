defmodule Shunt do

  def find(_, []) do [] end
  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)

    [{:one, 1 + Enum.count(ts)},
    {:two, Enum.count(hs)},
    {:one, -(1 + Enum.count(ts))},
    {:two, -(Enum.count(hs))} | find(Train.append(ts, hs), ys)]
  end

  def few(_, []) do [] end
  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    if Enum.count(hs) == 0 do
      few(ts, ys)
    else
      [{:one, 1 + Enum.count(ts)},
      {:two, Enum.count(hs)},
      {:one, -(1 + Enum.count(ts))},
      {:two, -(Enum.count(hs))} | few(Train.append(ts, hs), ys)]
    end
  end

  def compress(ms) do
    ns = rules(ms)
    cond do
      ns == ms ->
        ms
      true ->
        compress(ns)
    end
  end

  def rules([]) do [] end
  def rules([{track, n} | moves]) do
    cond do
      n == 0 ->
        rules(moves)
      moves != [] ->
        [{nextTrack, m} | nextMoves] = moves
        cond do
          track == :one && nextTrack == :one ->
            [{:one, n + m} | rules(nextMoves)]
          track == :two && nextTrack == :two ->
            [{:two, n + m} | rules(nextMoves)]
          true ->
            [{track, n} | rules(moves)]
        end
      true ->
        [{track, n}]
    end
  end

  def fewer(_, _, _, []) do [] end
  def fewer(ms, hs, ts, [y | ys]) do
    cond do
      Train.member(ms, y) ->
        {hsSplit, tsSplit} = Train.split(ms, y)
        moves = [
          {:one, 1 + Enum.count(tsSplit)},
          {:two, Enum.count(hsSplit)},
          {:one, -1}
        ]

        [{ms, hs, ts}] = Enum.take(Moves.move(moves, {ms, hs, ts}), -1)
        moves ++ fewer(ms, hs, ts, ys)

      Train.member(hs, y) ->
        {hsSplit, _} = Train.split(hs, y)
        moves = [
          {:one, -Enum.count(hsSplit)},
          {:two, Enum.count(hsSplit)},
          {:one, -1}
        ]

        [{ms, hs, ts}] = Enum.take(Moves.move(moves, {ms, hs, ts}), -1)
        moves ++ fewer(ms, hs, ts, ys)

      Train.member(ts, y) ->
        {hsSplit, _} = Train.split(ts, y)
        moves = [
          {:two, -Enum.count(hsSplit)},
          {:one, Enum.count(hsSplit)},
          {:two, -1}
        ]

        [{ms, hs, ts}] = Enum.take(Moves.move(moves, {ms, hs, ts}), -1)
        moves ++ fewer(ms, hs, ts, ys)
    end
  end

end
