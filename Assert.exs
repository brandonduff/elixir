defmodule Assert do
  def assert(:false), do: raise "Assertion failed"
  def assert(_), do: true

  def assert_equal(actual, actual), do: true
  def assert_equal(actual, expected),
      do: raise "Expected #{Kernel.inspect(actual)} to equal #{Kernel.inspect(expected)}"
end
