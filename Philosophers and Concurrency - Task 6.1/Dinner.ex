defmodule Dinner do

  def start(), do: spawn(fn -> init() end)
  def init() do
    seed = 3;
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(50, c1, c2, "Arendt", ctrl,1)
    Philosopher.start(50, c2, c3, "Hypatia", ctrl, 3)
    Philosopher.start(50, c3, c4, "Simone", ctrl, 3)
    Philosopher.start(50, c4, c5, "Elisabeth", ctrl, 4)
    Philosopher.start(50, c5, c1, "Ayn", ctrl, 5)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n - 1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end


end
