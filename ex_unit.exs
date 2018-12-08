Code.require_file("Assert.exs")

defmodule WasRun do
  import Map

  def set_up(set_up) do
    %{ set_up: set_up }
  end

  def run(test) do
    test.set_up.() |> test.execute.() |> tear_down
  end

  def tear_down(result) do
    merge(result, %{ log: result.log <> "tearDown" }) 
  end

  def specify(context, specification) do
    merge(context, %{ execute: specification })
  end
end

context = WasRun.set_up(fn -> %{ log: "setUp " } end)
test = WasRun.specify(context, fn (context) ->
  Map.merge(context, %{ log: context.log <> "run " })
end)

result = WasRun.run(test)
Assert.assert_equal(result.log, "setUp run tearDown")

IO.puts 'success'
