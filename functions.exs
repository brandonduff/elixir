fizz_buzz = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, a -> a
end

run_fizz = fn n -> fizz_buzz.(rem(n, 3), rem(n, 5), n) end

# IO.puts run_fizz.(10)
# IO.puts run_fizz.(11)
# IO.puts run_fizz.(12)
# IO.puts run_fizz.(13)
# IO.puts run_fizz.(14)
# IO.puts run_fizz.(15)
# IO.puts run_fizz.(16)
# IO.puts run_fizz.(17)

prefix = fn prefix ->
  fn suffix -> "#{prefix} #{suffix}" end
end

mrs = prefix.("Mrs")
# IO.puts(mrs.("Smith"))

IO.puts(Enum.map [1, 2, 3, 4], &(&1 + 2))
IO.puts Enum.each [1, 2, 3, 4], &(IO.inspect(&1))


