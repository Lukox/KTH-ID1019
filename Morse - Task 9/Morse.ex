defmodule Morse do

  def encode_table({:node, :na, left, right}, map, path) do
    encode_table(right, encode_table(left, map, path <> "-"), path <> ".")
  end
  def encode_table({:node, char, :nil, :nil}, map, path) do
    Map.put(map, [char], path)
  end
  def encode_table({:node, char, left, :nil}, map, path) do
    Map.put(encode_table(left, map, path <> "-"), [char], path)
  end
  def encode_table({:node, char, :nil, right}, map, path) do
    Map.put(encode_table(right, map, path <> "."), [char], path)
  end
  def encode_table({:node, char, left, right}, map, path) do
    lmap = encode_table(left, map, path <> "-")
    rmap = encode_table(right, lmap, path <> ".")
    Map.put(rmap, [char], path)
  end
  def encode_table(_, map, _) do map end

  def encode(text)do
    tree = morse()
    table = encode_table(tree, %{}, "")
    encode(table, String.to_charlist(text), [])
  end

  def encode(table, [head | tail], result) do
    encode(table, tail, [Map.get(table, [head]) <> " " | result])
  end
  def encode(_, [], result) do
    unpack(result, "")
  end

  def unpack([], sofar) do sofar end
  def unpack([c | rest], sofar) do
    unpack(rest, c <> sofar)
  end


  def decode(morse) do
    table = morse()
    ##morse = ".- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ..."
    ##morse = ".... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- "
    morse = String.split(morse)
    decode(morse, table)
  end

  def decode([], _) do [] end
  def decode([head|tail], table) do
    [decode_chars(String.codepoints(head), table) | decode(tail, table)]
  end

  def decode_chars([], {:node, char, _, _}) do char end
  def decode_chars(["-"|tail], {:node, _, left, _}) do
    decode_chars(tail, left)
  end
  def decode_chars(["."|tail], {:node, _, _, right}) do
   decode_chars(tail, right)
  end

  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
    end


end
