
defmodule Expression do

  def test1() do
    env = new([{:x, {:num, 2}}, {:y, {:num, 3}}])
    expression = {:sub, {:mul, {:div, {:num, 3}, {:num, 2}}, {:var, :x}}, {:q, {:num,1}, {:num, 2}}}
    e = eval(expression, env)
    IO.write("Evaluated Expression: #{pprint(e)}\n")
  end

  def test2() do
    env = new([{:x, {:num, 2}}, {:y, {:num, 3}}])
    expression = {:div, {:mul, {:num, 2}, {:mul, {:var, :x}, {:var, :y}}}, {:num, 12}}
    e = eval(expression, env)
    IO.write("Evaluated Expression: #{pprint(e)}\n")
  end

  def test3() do
    env = new([{:x, {:num, 2}}, {:y, {:num, 3}}])
    expression = {:add, {:div, {:var, :x}, {:num, 2}}, {:q, {:num, 1}, {:num, 2}}}
    e = eval(expression, env)
    IO.write("Evaluated Expression: #{pprint(e)}\n")
  end

  def new() do Map.new() end
  def new(enumerable) do Map.new(enumerable) end

  def lookup(map, key) do Map.get(map, key) end

  def eval({:num, n}, _) do {:num, n} end
  def eval({:q, {:num,n1}, {:num,n2}}, _) do {:q, {:num,n1}, {:num,n2}} end
  def eval({:var, var}, env) do lookup(env, var) end
  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end
  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end
  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end
  def eval({:div, e1, e2}, env) do
    divide(eval(e1, env), eval(e2, env))
  end

  def add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def add({:num, n1}, {:q, {:num,n2}, {:num,n3}}) do {:q, {:num,n1*n3+n2}, {:num,n3}} end
  def add({:q, {:num,n2}, {:num,n3}}, {:num, n1}) do {:q, {:num,n1*n3+n2}, {:num,n3}} end
  def add({:q, {:num,n1}, {:num,n2}}, {:q, {:num,n3}, {:num,n4}}) do simplify({:q, {:num,n1*n4+n2*n3}, {:num,n2*n4}}) end

  def sub({:num, n1}, {:num, n2}) do {:num, n1 - n2} end
  def sub({:num, n1}, {:q, {:num,n2}, {:num,n3}}) do {:q, {:num,n1*n3-n2}, {:num,n3}} end
  def sub({:q, {:num,n2}, {:num,n3}}, {:num, n1}) do {:q, {:num,((-n1)*n3)+n2}, {:num,n3}} end
  def sub({:q, {:num,n1}, {:num,n2}}, {:q, {:num,n3}, {:num,n4}}) do simplify({:q, {:num,n1*n4-n2*n3}, {:num,n2*n4}}) end

  def mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
  def mul({:num, n1}, {:q, {:num,n2}, {:num,n3}}) do simplify({:q, {:num,n1*n2}, {:num,n3}}) end
  def mul({:q, {:num,n2}, {:num,n3}}, {:num, n1}) do simplify({:q, {:num,n1*n2}, {:num,n3}}) end
  def mul({:q, {:num,n1}, {:num,n2}}, {:q, {:num,n3}, {:num,n4}}) do simplify({:q, {:num,n1*n3}, {:num,n2*n4}}) end

  def divide({:num, n1}, {:num, n2}) do simplify({:q, {:num,n1}, {:num,n2}}) end
  def divide({:num, n1}, {:q, {:num,n2}, {:num,n3}}) do simplify({:q, {:num,n1*n3}, {:num,n2}}) end
  def divide({:q, {:num,n2}, {:num,n3}}, {:num, n1}) do simplify({:q, {:num,n1*n3}, {:num,n2}}) end
  def divide({:q, {:num,n1}, {:num,n2}}, {:q, {:num,n3}, {:num,n4}}) do simplify({:q, {:num,n1*n4}, {:num,n2*n3}}) end

  def simplify({:q, {:num,n1}, 1}) do {:num, n1} end
  def simplify({:q, {:num,n1}, {:num,n2}}) do
    if(n2/gcd(n1,n2) == 1) do
      {:num, trunc(n1/gcd(n1,n2))}
    else
      {:q, {:num,trunc(n1/gcd(n1,n2))}, {:num,trunc(n2/gcd(n1,n2))}}
    end
  end

  def gcd(n1, 0) do n1 end
  def gcd(n1, n2) do gcd(n2, rem(n1, n2)) end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:q, {:num, n1}, {:num, n2}}) do "(#{pprint({:num,n1})}/#{pprint({:num,n2})})" end

end
