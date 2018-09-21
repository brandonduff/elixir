defmodule MyListTest do
  use ExUnit.Case
  import MyList

  test "foo" do
    assert_equal(map([], fn arg -> arg end), [])
    assert_equal(map([1], fn item -> item * 2 end), [2])
    assert_equal(map([1, 2], fn item -> item * 2 end), [2, 4])

    assert_equal(sum([]), 0)
    assert_equal(sum([1]), 1)
    assert_equal(sum([1, 2]), 3)

    assert_equal(mapsum([], fn -> nil end), 0)
    assert_equal(mapsum([1, 2], fn item -> item * 2 end), 6)
  end
end
