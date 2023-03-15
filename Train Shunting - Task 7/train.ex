defmodule Train do

  def take([], _) do [] end
  def take(_, 0) do [] end
  def take([head|tail], n) do
    [head|take(tail, n - 1)]
  end

  def drop([], _) do [] end
  def drop(train, 0) do train end
  def drop([_|tail], n) do
    drop(tail,n-1)
  end

  def append(train, train2) do train ++ train2 end

  def member([], _) do false end
  def member([y|_], y) do true end
  def member([_, t], y) do member(t, y) end

  def position([y|_], y) do 1 end
  def position([_, t], y) do position(t, y) + 1 end

  def split([y|t], y) do  {[], t}  end
  def split([head|tail], y) do
    {tail, rest} = split(tail, y)
    {[head|tail], rest}
  end

  def main([], n) do {n, [], []} end
  def main([head|tail], n) do
      case main(tail, n) do
	      {0, rest, take} ->
	        {0, [head|rest], take}
	      {n, rest, take} ->
	        {n-1, rest, [head|take]}
      end
  end

end
