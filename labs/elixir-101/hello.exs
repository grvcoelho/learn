IO.puts "Hello world from Elixir"

IO.puts "-------------------------------------------"

add = fn a, b -> a + b end
double = fn a -> add.(a, a) end

IO.puts double.(2)
IO.puts double.(3)

IO.puts "-------------------------------------------"

tuple = {1, 2, 3}

result = case tuple do
  {1, x, 3} when x > 0 ->
    "Will Match #{x}"
  _ -> "Would match, if guard condition were not satisfied"
end

IO.puts result

IO.puts "-------------------------------------------"

f = fn
  x, y when x > y -> x + y
  x, y -> x * y
end

IO.puts f.(2, 5)
IO.puts f.(5, 2)

IO.puts "-------------------------------------------"

result = cond do
  2 + 2 == 5 -> "This will not be true"
  2 * 2 == 3 -> "Nor this"
  1 + 1 == 2 -> "But this will"
  true -> "All else"
end

IO.puts result

IO.puts "-------------------------------------------"

if true do
  IO.puts "This works!"
end

unless true do
  IO.puts "This will never be seen"
end

if nil do
  IO.puts "This will not be seen"
else
  IO.puts "Else"
end

x = if(true, do: "If is actually a macro")

IO.puts(x)




# On'(' make a new subtree
def parse(["(" | tail], acc) do
   {rem_tokens, sub_tree} = parse(tail, [])
   parse(rem_tokens, [sub_tree | acc])
end

# On ')' accumulate the current sub tree in the parent tree
def parse([")" | tail], acc) do
   {tail, Enum.reverse(acc)}
end

# On end of tokens roll back and start accumulating
def parse([], acc) do
   Enum.reverse(acc)
end

# On a symbol accumulate it and parse remaining tokens
def parse([head | tail], acc) do
   parse(tail, [atom(head) | acc])
end


