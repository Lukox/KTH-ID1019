defmodule Day16 do

  def task(t) do
    start = :AA

    rows = File.stream!("day16.csv")
    map = Map.new(parse(rows))

    valuable = Enum.map((Enum.filter(map, fn({_,{rate,_}}) -> rate != 0 end)), fn({valve, _}) -> valve end)
    getMaxPressure(paths(map, valuable), start, t, 0, valuable, map)

  end

  def getMaxPressure(_,_,0,pressure,_,_) do pressure end
  def getMaxPressure(_,_,_,pressure,[],_) do pressure end
  def getMaxPressure(map, nodeAt, time, pressure, valuable, valves) do
    currentMap = Enum.filter(map, fn {{k1,k2}, _} ->
      k1 == nodeAt && k1 != k2 && Enum.member?(valuable, k2) end)
    Enum.reduce(currentMap, pressure,fn {{_, next}, dist}, max ->
      newTime = max(time-dist-1, 0)
      rate =  elem(Map.get(valves, next), 0)
      p = getMaxPressure(map, next, newTime, pressure + (newTime*rate), List.delete(valuable, next),valves)
      if(p > max) do
        p
      else
        max
      end
    end)
  end

  def paths(map, closed) do
    graph = make_graph(map)
    graph = Enum.filter(graph, fn {{k1,k2}, _} ->
      (Enum.member?(closed, k1) && Enum.member?(closed, k2)) || k1 == :AA
    end)
    Map.new(graph)
  end

  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end

  def make_graph(map) do
    graph = edges(map)
    graph = Enum.filter(graph, & !is_nil(&1))
    dist = s(graph, map)
    dist = shortest_path(dist, map)
  end

  def edges(map) do
    for {node, {_, edges}} <- map,
    {edge, {_, _}} <- map,
    node != edge do
      if Enum.member?(edges, edge) do
        {node, edge, 1}
      end
    end
  end

  def s(edge, map) do
    big = 1000000
    dist = for {node,{_,_}} <- map,
     {node2,{_,_}} <- map,
     into: %{},
     do: {{node,node2},(if node == node2, do: 0, else: big)}
    Enum.reduce(edge, dist, fn {u,v,w},dst ->
      Map.put(dst, {u,v}, w)
    end)
  end

  def shortest_path(dist, map) do
    (for {node1,{_,_}} <- map,
    {node2,{_,_}} <- map,
    {node3,{_,_}} <- map,
    do: {node1, node2, node3})
    |> Enum.reduce(dist, fn {node1,node2,node3},dst ->
      if dst[{node2,node3}] > dst[{node2,node1}] + dst[{node1,node3}] do
        Map.put(dst, {node2,node3}, dst[{node2,node1}] + dst[{node1,node3}])
      else
        dst
      end
    end)
  end

end
