defmodule Hof do

  def double_five_animal([], _) do [] end
  def double_five_animal([head|tail], operation) do
    case operation do
      :double -> [2*head|double_five_animal(tail, :double)]
      :five -> [head + 5|double_five_animal(tail, :five)]
      :animal ->
        if(head == :dog) do
          [:fido|double_five_animal(tail, :animal)]
        else
          [head|double_five_animal(tail, :animal)]
        end
    end
  end

  def double(list) do double_five_animal(list, :double) end
  def five(list) do double_five_animal(list, :five) end
  def animal(list) do double_five_animal(list, :animal) end

  def apply_to_all([], _) do [] end
  def apply_to_all([head|tail], function) do
    [function.(head)|apply_to_all(tail, function)]
  end

  def sum([]) do 0 end
  def sum([head|tail]) do
    head + sum(tail)
  end

  def fold_right([], base, _ ) do base end
  def fold_right([head|tail], base, f ) do
    f.(head, fold_right(tail, base, f))
  end

  def fold_left([], base, _ ) do base end
  def fold_left([head|tail], base, f ) do
    fold_left(tail, f.(head, base), f)
  end

  def odd([]) do [] end
  def odd([head|tail]) do
    if (rem(head,2) == 1) do
      [head|odd(tail)]
    else
      odd(tail)
    end
  end

  def filter([], _) do [] end
  def filter([head|tail], f) do
    if(f.(head)) do
      [head|filter(tail, f)]
    else
      filter(tail,f)
    end
  end
end
