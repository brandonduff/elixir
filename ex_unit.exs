Code.require_file("Assert.exs")

defmodule Test do
  def init(test_module) do
    %{ was_run: false, was_set_up: false, test_module: test_module }
  end

  def run(test, args) do
    result = apply(test.test_module.set_up, args)
    apply(test.test_module.test, [result])
  end
end

defmodule WasRun do
  def set_up do
    fn result -> %{ result | was_set_up: true, was_run: false } end
  end

  def test do
    fn result -> %{ result | was_run: true } end
  end
end

defmodule TestCaseTest do
  import Assert

  def test_running do
    test = Test.init(WasRun)
    assert(!test.was_run)
    result = Test.run(test, [test])
    assert(result.was_run)
    IO.puts "Success!"
  end

  def test_set_up do
    test = Test.init(WasRun)
    result = Test.run(test, [test])
    assert(result.was_set_up)
    IO.puts "Success!"
  end 
end

TestCaseTest.test_running()
TestCaseTest.test_set_up()
