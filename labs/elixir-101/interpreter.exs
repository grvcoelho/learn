defmodule Interpreter do
  defp tokenize(str) do
    str
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split()
  end

  defp atom(x) do
    x
  end

  # On '(' make a new subtree
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

  def eval(program) do
    program
    |> tokenize
    |> parse
  end
end


program = "(begin (define r 10) (* pi (* r r)))"

output = Interpreter.eval(program)

IO.inspect(output)

