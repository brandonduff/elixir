defmodule Assert do
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

  def max([current | [head | tail]]) when head >= current do
    max([head | tail])
  end

  def span(from, to) when to < from, do: []
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

  def flatten([h | t]) do
    flatten(h) ++ flatten(t)
  end
  def flatten([]), do: []
  def flatten(el), do: [el]

  def total(tax_rates, items) do
    for item <- items, do: total_item(item, tax_rates[item[:ship_to]])
  end

  defp total_item(item, tax_rate) do
    item ++ [ total_amount: item[:net_amount] + item[:net_amount] * (tax_rate || 0) ]
  end

  def printable?(list) do
    Enum.all?(list, fn c -> c >= ?\s && c <= ?\~ end)
  end

  def anagram?(first, second) do
    first == Enum.reverse(second)
  end

  def center([string]), do: string
  def center(string_list) do
    longest_string = string_list
          |> map(&String.length/1)
          |> max

    Enum.join(map(string_list, fn string -> pad(string, longest_string) end), "\n") <> "\n"
  end

  defp pad(string, num) do
    difference = num - String.length(string)
    left_padding = get_padding_string(div(difference + 1, 2))
    right_padding = get_padding_string(rem(difference - 1, 2))
    left_padding <> string <> right_padding 
  end

  defp get_padding_string(length) do
    nums = span(1, length)
    Enum.join(map(nums, fn _ -> " " end))
  end
end

defmodule MyListTests do
  import Assert
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

  assert_equal(flatten([]), [])
  assert_equal(flatten([1]), [1])
  assert_equal(flatten([[]]), [])
  assert_equal(flatten([1, 2]), [1, 2])
  assert_equal(flatten([1, [2]]), [1, 2])
  assert_equal(flatten([1, [2, 3]]), [1, 2, 3])
  assert_equal(flatten([1, [2, [3]]]), [1, 2, 3])
  assert_equal(flatten([[1, [[2, [[3]]]]]]), [1, 2, 3])
  assert_equal(flatten([[[1]], [2]]), [1, 2])

  assert_equal(total([], [[ id: 123, ship_to: :UT, net_amount: 100 ]]),
    [[ id: 123, ship_to: :UT, net_amount: 100, total_amount: 100 ]])

  assert_equal(total([UT: 0.075], [[ id: 123, ship_to: :UT, net_amount: 100 ]]),
    [[ id: 123, ship_to: :UT, net_amount: 100, total_amount: 107.5 ]])

  assert_equal(printable?([]), true)
  assert_equal(printable?([?\s]), true)
  assert_equal(printable?([?\s - 1]), false)
  assert_equal(printable?([?\~ + 1]), false)
  assert_equal(printable?([?\s, ?\~ + 1]), false)
  assert_equal(printable?([?\s, ?\s]), true)

  assert_equal(anagram?('', ''), true)
  assert_equal(anagram?('a', 'b'), false)
  assert_equal(anagram?('a', 'ba'), false)
  assert_equal(anagram?('ab', 'ba'), true)

  assert_equal(center([""]), "")
  assert_equal(center(["a", "b"]),
    """
    a
    b
    """
  )
  assert_equal(center(["a", "bb"]),
    """
     a
    bb
    """
  )
  assert_equal(center(["a", "bbb"]),
    """
     a 
    bbb
    """
  )
  assert_equal(center(["aa", "bbb"]),
    """
     aa
    bbb
    """
  )
  assert_equal(center(["aaa", "bbb"]),
    """
    aaa
    bbb
    """
  )
  assert_equal(center(["a", "bbbb"]),
    """
      a
    bbbb
    """
  )
  assert_equal(center(["aa", "bbbb"]),
    """
     aa 
    bbbb
    """
  )
  assert_equal(center(["aa", "bbbb", "ccc"]),
    """
     aa 
    bbbb
     ccc
    """
  )
  assert_equal(center(["aa", "bbbbb", "ccc"]),
    """
      aa
    bbbbb
     ccc 
    """
  )
  IO.puts "success!"
end

