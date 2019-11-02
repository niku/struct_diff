# StructDiff

Calculates the difference between two structs.

If you would like to calculate map difference and/or nested struct difference, you might use [Qqwy/elixir-map_diff](https://github.com/Qqwy/elixir-map_diff).

## Usage

```elixir
defmodule A, do: defstruct [:x, :y, :z]
defmodule B, do: defstruct [:x, :y, :z]

StructDiff.diff(%A{x: 1, y: 2, z: 3}, %A{x: 1, y: 2, z: 3})
# => {:ok, %{}}

StructDiff.diff(%A{x: 100, y: 2, z: 3}, %A{x: 1, y: 2, z: 30})
# => {:ok, %{x: {100, 1}, z: {3, 30}}}

StructDiff.diff(%A{x: 1, y: 2, z: 3}, %B{x: 1, y: 2, z: 3})
# => {:error, {:different_struct_given, A, B}}

StructDiff.diff(%{}, %A{})
# => {:error, {:no_struct_given, :the_first}}

# Limitation, it calculates only top level diffs, doesn't calculate nested structs
StructDiff.diff(%A{x: 1, y: 2, z: %B{x: 3, y: 4, z: 5}}, %A{x: 1, y: 2, z: %B{x: 30, y: 40, z: 50}})
# => {:ok, %{z: {%B{x: 3, y: 4, z: 5}, %B{x: 30, y: 40, z: 50}}}}
```

## Installation

Add `niku/struct_diff` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:struct_diff, github: "niku/struct_diff"}
  ]
end
```
