# The Fibonacci sequence
# 0, 1, 1, 2, 3, 5, 8, 13, 21, 34

# This impl is not tail-call optimized
#
# defmodule Fib do
#   def find(1) do 1 end
#   def find(2) do 1 end
#   def find(n) do find(n - 2) + find(n - 1) end
# end

# This impl creates a fib function that receive the computed values a and b
# as well as n, so we don't need to compute n calls of fib before returning a
# value
#
# defmodule Fib do
#   def find(1) do 1 end
#   def find(2) do 1 end
#
#   def find(n) do
#     fib(1, 1, n)
#   end
#
#   def fib(a, _, 1) do a end
#
#   def fib(a, b, n) do
#     fib(b, a+b, n-1)
#   end
# end

# This solution returns a list of numbers until the nth position

defmodule Fib do
  def find(n) do
    list = [1, 1]
    fib(list, n)
  end

  def fib(list, 2) do
    Enum.reverse(list)
  end

  def fib(list, n) when n > 2 do
    [a, b | _] = list
    new_list = [a+b | list]
    fib(new_list, n-1)
  end
end

IO.inspect Fib.find(10) # 55
