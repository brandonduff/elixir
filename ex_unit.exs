Code.require_file("Assert.exs")

defmodule Test do
  def init(test_method) do
    %{ was_run: false, test_method: test_method }
  end

  def run(test, args) do
    apply(test.test_method, args)
  end

end

defmodule TestCaseTest do
  import Assert

  def test_running do
    test = Test.init(fn test -> %{ test | was_run: true } end)
    assert(!test.was_run)
    result = Test.run(test, [test])
    assert(result.was_run)
    IO.puts "Success!"
  end
end

TestCaseTest.test_running()
