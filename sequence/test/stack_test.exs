defmodule StackTest do
  use ExUnit.Case

  test "can be popped" do
    {:ok, pid} = GenServer.start_link(Sequence.Stack, [42])
    assert 42 == GenServer.call(pid, :pop)
  end

  test "can be pushed" do
    {:ok, pid} = GenServer.start_link(Sequence.Stack, [42])
    GenServer.cast(pid, {:push, 666})
    assert 666 == GenServer.call(pid, :pop)
  end
end
