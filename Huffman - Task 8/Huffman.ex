defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'hello'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    freq = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
    huffman(freq)
  end

  def freq(sample) do freq(sample, %{}) end
  def freq([], map) do map end
  def freq([char | rest], map) do
    case Map.get(map, char) do
      nil ->
        freq(rest, Map.put(map, char, 1))
      value ->
        freq(rest, Map.put(map, char, value + 1))
    end
  end

  def huffman([{tree, _}]) do tree end
  def huffman([{key, value}, {key2, value2} | rest]) do
    huffman(insert({key, value}, {key2, value2}, rest))
  end

  def insert({key1, value1}, {key2, value2}, []) do
    [{{key1, key2}, value1 + value2}]
  end
  def insert({key1, value1}, {key2, value2}, [{key3, value3} | rest]) do
    if value1 + value2 < value3 do
      [{{key1, key2}, value1 + value2}] ++ [{key3, value3} | rest]
    else
      [{key3, value3}] ++ insert({key1, value1}, {key2, value2}, rest)
    end
  end

  def encode_table(tree) do
    encode_table(tree, [])
  end
  def encode_table({left, right}, path) do
    leftp = encode_table(left, path ++ [0])
    rightp = encode_table(right, path ++ [1])
    leftp ++ rightp
  end
  def encode_table(tree, path) do
    [{tree, path}]
  end

  def decode_table(tree) do
    encode_table(tree)
  end

  def encode([], _) do [] end
  def encode([char | rest], table) do
    {_, bits} = Enum.find(table, fn {c, _} -> c == char end)
    bits ++ encode(rest, table)
  end

  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest};
      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, rest} ->
      {list, length - byte_size(rest)}
    list ->
      {list, length}
    end
  end

  def bench() do
    {text, length} = read("data.txt")
    {tree, tree_time} = time(fn -> tree(text) end)
    {encode_table, encode_table_time} = time(fn -> encode_table(tree) end)
    {decode_table, decode_table_time} = time(fn -> decode_table(tree) end)
    {encode, encode_time} = time(fn -> encode(text, encode_table) end)
    {_, decoded_time} = time(fn -> decode(encode, decode_table) end)

    e = div(length(encode), 8)
    r = Float.round(e / length, 3)

    IO.puts("Tree Build Time: #{tree_time} us")
    IO.puts("Encode Table Time: #{encode_table_time} us")
    IO.puts("Decode Table Time: #{decode_table_time} us")
    IO.puts("Encode Time: #{encode_time} us")
    IO.puts("Decode Time: #{decoded_time} us")
    IO.puts("Compression Ratio: #{r}")
  end

  def time(func) do
    {func.(), elem(:timer.tc(fn () -> func.() end), 0)}
  end


end
