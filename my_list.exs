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

  def all?([], _func), do: true
  def all?([h | t], func) do
    func.(h) && all?(t, func)
  end

  def each(list = [], _), do: list
  def each([h | t] = list, func) do
    func.(h)
    each(t, func)
    list
  end

  def filter(list = [], _), do: list
  def filter([h | t], func) do
    if func.(h) do
      [h] ++ filter(t, func)
    else
      filter(t, func)
    end
  end

  def split(list, count) do
    split(list, [], count)
  end

  defp split(list, left, count) when count <= 0 do
    [left, list]
  end

  defp split([head | tail], left, count) when count > 0 do
    split(tail, left ++ [head], count - 1)
  end

  def take(_list, 0), do: []
  def take([], _count), do: []
  def take([h | t], count) do
   [h] ++ take(t, count - 1)
  end
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

  assert_equal(all?([], fn _ -> true end), true)
  assert_equal(all?([], fn _ -> false end), true)
  assert_equal(all?([1], fn _ -> false end), false)
  assert_equal(all?([1, 2], fn _ -> false end), false)
  assert_equal(all?([1, 2], fn _ -> true end), true)
  assert_equal(all?([true, false], fn el -> el end), false)

  assert_equal(each([], fn -> raise "shouldn't be called" end), [])
  assert_equal(each([1], fn (el) -> assert_equal(1, el) end), [1])

  assert_equal(filter([], fn _ -> nil end), [])
  assert_equal(filter([1], fn _ -> true end), [1])
  assert_equal(filter([1], fn _ -> false end), [])
  assert_equal(filter([1, 2], fn _ -> true end), [1, 2])
  assert_equal(filter([1, 2], fn _ -> false end), [])
  assert_equal(filter([true, false], fn el -> el end), [true])
  assert_equal(filter([false, true], fn el -> el end), [true])
  assert_equal(filter([false, true, false, true], fn el -> el end), [true, true])

  assert_equal(split([], 0), [[], []])
  assert_equal(split([1], 0), [[], [1]])
  assert_equal(split([1], 1), [[1], []])
  assert_equal(split([1,2], 1), [[1], [2]])
  assert_equal(split([1,2], 2), [[1, 2], []])
  assert_equal(split([1,2,3], 3), [[1, 2, 3], []])
  assert_equal(split([1,2,3], 0), [[], [1, 2, 3]])
  assert_equal(split([1,2,3,4], 2), [[1, 2], [3, 4]])

  assert_equal(take([], 0), [])
  assert_equal(take([1], 0), [])
  assert_equal(take([1], 1), [1])
  assert_equal(take([1, 2], 1), [1])
  assert_equal(take([1, 2], 2), [1, 2])
  assert_equal(take([1, 2], 3), [1, 2])
  assert_equal(take([1, 2, 3], 2), [1, 2])
  assert_equal(take([1, 2, 3, 4], 3), [1, 2, 3])

  IO.puts "success!"
end

