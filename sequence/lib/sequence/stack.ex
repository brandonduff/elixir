defmodule Sequence.Stack do
  use GenServer

  def init(initial_stack) do
    { :ok, initial_stack }
  end

  def handle_call(:pop, _from, stack) do
    {val, remainder} = List.pop_at(stack, 0)
    {:reply, val, remainder}
  end

  def handle_cast({:push, val}, stack) do
    {:noreply, [val | stack]}
  end
end
