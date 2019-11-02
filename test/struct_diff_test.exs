defmodule StructDiffTest do
  use ExUnit.Case
  doctest StructDiff

  defmodule StructA, do: defstruct([:x, :y, :z])
  defmodule StructB, do: defstruct([:x, :y, :z])

  test "Returns an empty map when same values are given" do
    assert {:ok, %{}} == StructDiff.diff(%StructA{x: 1, y: 2, z: 3}, %StructA{x: 1, y: 2, z: 3})
  end

  test "Returns difference as a map that has each values as a two element tuple" do
    assert {:ok, %{x: {10, 1}, z: {3, 30}}} == StructDiff.diff(%StructA{x: 10, y: 2, z: 3}, %StructA{x: 1, y: 2, z: 30})
  end

  test "Returns the top level difference even there have nested struct" do
    assert {:ok,
            %{
              x: {
                %StructA{x: 4, y: 5, z: 6},
                %StructA{x: 4, y: 5, z: 60}
              }
            }} ==
             StructDiff.diff(
               %StructA{x: %StructA{x: 4, y: 5, z: 6}, y: 2, z: 3},
               %StructA{x: %StructA{x: 4, y: 5, z: 60}, y: 2, z: 3}
             )
  end

  test "Returns an error when different struct are given even if both structs have same elements" do
    assert {:error, {:different_struct_given, StructA, StructB}} ==
             StructDiff.diff(%StructA{x: 1, y: 2, z: 3}, %StructB{x: 1, y: 2, z: 3})
  end

  test "Returns an error when both struct have same name but one has extra key" do
    assert {:error, {:different_keys_with_same_struct_name_given, [:a, :b]}} ==
             StructDiff.diff(%{__struct__: StructA, x: 1, y: 2, z: 3, a: 4, b: 5}, %StructA{x: 1, y: 2, z: 3})
  end

  test "Returns an error when no struct is given as the first argument" do
    assert {:error, {:no_struct_given, :the_first}} == StructDiff.diff(%{}, %StructA{})
  end

  test "Returns an error when no struct is given as the second argument" do
    assert {:error, {:no_struct_given, :the_second}} == StructDiff.diff(%StructA{}, %{})
  end

  test "Returns an error when no structs are given as both arguments" do
    assert {:error, {:no_struct_given, :both}} == StructDiff.diff(%{}, %{})
  end
end
