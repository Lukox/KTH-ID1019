defmodule Aoc4 do

  ##Part1

  def solve() do
    {:ok, contents} = File.read("puzzle.txt")
    contents = String.split(contents, "\r\n")
      Enum.count(sets(contents), fn [range1, range2] ->
        MapSet.subset?(range1, range2) || MapSet.subset?(range2, range1) end)
  end

  def sets([]) do [] end
  def sets([head|tail]) do
    [set1, set2] = String.split(head, ",")
    [[ranges(set1), ranges(set2)] | sets(tail)]
  end

  def ranges(set) do
    [min, max] = String.split(set, "-")
    MapSet.new(String.to_integer(min)..String.to_integer(max))
  end


  ##Part2

  def solve2() do
    {:ok, contents} = File.read("puzzle.txt")
    contents = String.split(contents, "\r\n")
    Enum.count(sets2(contents), fn [range1, range2] ->
      not Range.disjoint?(range1, range2) end)
  end

  def sets2([]) do [] end
  def sets2([head|tail]) do
    [set1, set2] = String.split(head, ",")
    [[ranges2(set1), ranges2(set2)] | sets2(tail)]
  end

  def ranges2(set) do
    [min, max] = String.split(set, "-")
    (String.to_integer(min)..String.to_integer(max))
  end

end
