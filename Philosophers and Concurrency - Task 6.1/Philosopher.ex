defmodule  Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl, seed) do
    spawn_link(fn -> init(hunger, right, left, name, ctrl, seed) end)
  end

  def init(hunger, right, left, name, ctrl, seed) do
    :rand.seed(:exsss, {seed, seed, seed})
    dream(hunger, right, left, name, ctrl)
  end

  def dream(0, _, _, name, ctrl) do
    IO.puts("#{name} is done eating -------------------" )
    send(ctrl, :ok)
  end
  def dream(hunger, right, left, name, ctrl) do
    sleep(1)
    IO.puts("#{name} wants to eat")
    chopsticks(hunger, right, left, name, ctrl)
  end

  def chopsticks(hunger, right, left, name, ctrl) do
    case Chopstick.request(right, 3) do
      :ok ->
        IO.puts("#{name} received a chopstick!")
        case Chopstick.request(left, 3) do
          :ok ->
            IO.puts("#{name} has both chopsticks!")
            eat(hunger, right, left, name, ctrl)
          :no ->
            IO.puts("#{name}'s left chopstick not available!")
            Chopstick.return(right, make_ref())
            dream(hunger, right, left, name, ctrl)
        end
      :no ->
        IO.puts("#{name}'s right chopstick not available!")
        dream(hunger, right, left, name, ctrl)
    end
  end

  def chopsticks2(hunger, right, left, name, ctrl) do
   lref =  make_ref()
   rref = make_ref()
   case Chopstick.request({left, right}, lref, rref, 100) do
      :ok ->
        IO.puts("#{name} has both chopsticks!")
        eat(hunger, right, left, name, ctrl,lref,rref)
      :no ->
        IO.puts("#{name} cant get both chopsticks!")
        dream(hunger, right, left, name, ctrl)
      ^rref ->
        Chopstick.return(right, rref)
        dream(hunger, right, left, name, ctrl)
      ^lref ->
        Chopstick.return(left, lref)
        dream(hunger, right, left, name, ctrl)
   end
  end

  def eat(hunger, right, left, name, ctrl) do
    sleep(0.25)
    IO.puts("#{name} finished eating 1 meal")
    Chopstick.return(right)
    Chopstick.return(left)
    dream(hunger - 1, right, left, name, ctrl)
  end
  def eat(hunger, right, left, name, ctrl,lref,rref) do
    sleep(1)
    IO.puts("#{name} finished eating 1 meal")
    Chopstick.return(right,rref)
    Chopstick.return(left,lref)
    dream(hunger - 1, right, left, name, ctrl)
  end

end
