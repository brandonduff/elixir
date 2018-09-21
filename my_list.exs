defmodule Test do
  def assert(:false), do: raise "Assertion failed"
  def assert(_), do: true

  def assert_equal(actual, actual), do: true
  def assert_equal(actual, expected),
      do: raise "Expected #{Kernel.inspect(actual)} to equal #{Kernel.inspect(expected)}"
end

defmodule MyList do
  def mapsum([], _func), do: 0
  def mapsum(list, func) do
    list
    |> map(func)
    |> sum
  end

  def map([], _), do: []
  def map([head | tail], func) do
    [func.(head) | map(tail, func)]
  end

  def sum([]), do: 0
  def sum([head | tail]) do
    head + sum(tail)
  end

  def max([current]), do: current
  def max([current | [head | tail]]) when current > head do
    max([current | tail])
  end

  def max([current | [head | tail]]) when head > current do
    max([head | tail])
  end

  def span(from, from), do: [from]
  def span(from, to), do: [from | span(from + 1, to)]
end

defmodule MyListTests do
  import Test
  import MyList

  assert_equal(map([], fn arg -> arg end), [])
  assert_equal(map([1], fn item -> item * 2 end), [2])
  assert_equal(map([1, 2], fn item -> item * 2 end), [2, 4])

  assert_equal(sum([]), 0)
  assert_equal(sum([1]), 1)

  assert_equal(sum([1, 2]), 3)
  assert_equal(mapsum([], fn -> nil end), 0)
  assert_equal(mapsum([1, 2], fn item -> item * 2 end), 6)

  assert_equal(max([1]), 1)
  assert_equal(max([1, 2]), 2)
  assert_equal(max([2, 1]), 2)

  assert_equal(span(1, 1), [1])
  assert_equal(span(1, 2), [1, 2])
  assert_equal(span(1, 3), [1, 2, 3])
  assert_equal(span(1, 4), [1, 2, 3, 4])

  IO.puts "success!"
end

