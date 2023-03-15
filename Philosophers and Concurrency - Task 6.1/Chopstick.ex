defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
    {:id, stick}
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      {:request, ref, from} ->
        send(from, {:granted, ref})
        gone(ref)
      :quit ->
        :ok
    end
  end

  def request({:id, stick}) do
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
    end
  end

  def request({:id, stick}, timeout) do
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
      after timeout -> :no
    end
  end

  ##ASYNCHRONOUS REQUEST

  def request({{:id,left}, {:id,right}}, lref, rref, timeout) do
    send(left, {:request, lref, self()})
    send(right, {:request, rref, self()})
    receive do
      {:granted, ^lref} ->
        case granted(rref, timeout) do
          :ok -> :ok
          :no ->
            lref
          end
      {:granted, ^rref} ->
        case granted(lref, timeout) do
          :ok -> :ok
          :no ->
            rref
        end
      after timeout ->
        :no
    end
  end

  def granted(ref, timeout) do
    receive do
      {:granted, ^ref} ->
        :ok
      {:granted, _} ->
        granted(ref, timeout)
    after
      timeout ->
        :no
    end
  end


  def quit({:id,stick}) do
    send(stick, :quit)
  end

  def return({:id, stick}) do
    send(stick, :return)
  end

  def return({:id, stick}, ref) do
    send(stick, {:return, ref})
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  defp gone(ref) do
    receive do
      {:return, ^ref}->
	      available()
      :quit ->
        :ok
    end
  end

end
