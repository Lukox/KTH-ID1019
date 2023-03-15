defmodule Moves do

  def single({_, 0}, state)  do state end
  def single({:one, n}, {main, one, two}) when n > 0 do
    {0, remain, taken} = Train.main(main, n)
    {remain, Train.append(taken, one), two}
  end
  def single({:one, n}, {main, one, two}) when n < 0 do
    taken = Train.take(one, -n)
    {Train.append(main, taken), Train.drop(one, -n), two}
  end
  def single({:two, n}, {main, one, two}) when n > 0 do
    {0, remain, taken} = Train.main(main,n)
    {remain, one, Train.append(taken, two)}
  end
  def single({:two, n}, {main, one, two}) when n < 0 do
    taken = Train.take(two, -n)
    {Train.append(main, taken), one, Train.drop(two, -n)}
  end

  def sequence([], state) do [state] end
  def sequence([move|moves], state) do
    [state|sequence(moves, single(move, state))]
  end

end
