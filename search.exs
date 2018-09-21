defmodule Search do
  def guess(number, first..last) do
    find_num(number, get_mid(first, last), first..last)
  end

  defp find_num(number, guess, first.._) when guess > number do
    IO.puts "Is it #{guess}"
    find_num(number, get_mid(guess - 1, first), first..(guess - 1))
  end

  defp find_num(number, guess, _..last) when guess < number do
    IO.puts "Is it #{guess}"
    find_num(number, get_mid(guess + 1, last), (guess + 1)..last)
  end

  defp find_num(number, guess, _) when guess == number do
    IO.puts guess
  end

  defp get_mid(first, last) do
    div(first + last, 2)
  end
end

Search.guess(2, 2..2)
Search.guess(5, 1..10)
Search.guess(11, 1..20)
