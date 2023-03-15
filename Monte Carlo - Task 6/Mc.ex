defmodule Mc do

  def rounds(k, j, r)  do
    a = round(j, r, 0)
    rounds(k, j, r, a)
  end

  def rounds(0, j, _, a) do 4*a/j end
  def rounds(k, j, r, a) do
    a = round(j, r, a)
    j = j*2
    pi = 4*a/j
    :io.format(" n = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [j, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    rounds(k-1, j, r, a)
  end


  def round(0, _, a) do a end
  def round(k, r, a) do
    if dart(r) do
      round(k-1, r, a+1)
    else
      round(k-1, r, a)
    end
  end


  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r,2) > (:math.pow(x,2) + :math.pow(y,2))
  end


end
