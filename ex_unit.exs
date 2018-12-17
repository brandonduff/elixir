Code.require_file("Assert.exs")

defmodule Test do
  import Map

  def set_up(set_up) do
    %{ set_up: set_up }
  end

  def tear_down(context, tear_down) do
    merge(context, %{ tear_down: tear_down })
  end

  def run(test) do
    test.set_up.() |> test.execute.() |> test.tear_down.()
  end

  def specify(context, specification) do
    merge(context, specify(specification))
  end

  def specify(specification) do
    %{ execute: specification }
  end
end

context = Test.set_up(fn -> %{ log: "setUp " } end)
test = Test.specify(context, fn (context) ->
  result = Map.merge(context, %{ log: context.log <> "run " })
  Assert.assert_equal(result.log, "setUp run ")
  result
end)
test = Test.tear_down(test, fn (context) ->
  Map.merge(context, %{ log: context.log <> "tearDown" })
end)

result = Test.run(test)
Assert.assert_equal(result.log, "setUp run tearDown")

IO.puts 'success'
