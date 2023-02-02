defmodule EnvList do
  def new() do [] end

  def lookup([], _) do  nil  end
  def lookup([{key,_}=value|_], key) do value end
  def lookup([_|map], key) do lookup(map, key) end

  def add([], key, value) do  [{key,value}] end
  def add([{key,_}|map], key, value) do [{key,value}|map] end
  def add([head|map], key, value) do
    [head|add(map, key,value)]
  end

  def remove([], _) do  []  end
  def remove([{key,_}|map], key) do map end
  def remove([head|map], key) do [head|remove(map, key)] end

  def bench() do bench(10000) end

  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) ->
    {i, tla, tll, tlr} = bench(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
    end)
  end


  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(), fn(e, list) ->
    EnvList.add(list, e, :foo)
    end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
    {add, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
    EnvList.add(list, e, :foo)
    end)
    end)
    {lookup, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
    EnvList.lookup(list, e)
    end)
    end)
    {remove, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
    EnvList.remove(list, e)
    end)
    end)
    {i, add, lookup, remove}
  end

end
