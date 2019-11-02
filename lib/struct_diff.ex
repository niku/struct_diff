defmodule StructDiff do
  @moduledoc """
  A module which calculates difference of two structs.
  """

  @doc """
  Gets difference of two structs.

  If given strucs have difference, it returns `{:ok, diff_map}`.
  A `diff_map` key is a key which has difference.
  A `diff_map` value is a tuple which has two elements. The first is a value of the first argument, the second is the second argument.
  """
  @spec diff(any(), any()) ::
          {:ok, map()}
          | {:error, {:different_keys_with_same_struct_name_given, [atom(), ...]}}
          | {:error, {:different_struct_given, module(), module()}}
          | {:error, {:no_struct_given, :the_first}}
          | {:error, {:no_struct_given, :the_second}}
          | {:error, {:no_struct_given, :both}}
  def diff(a, b)

  def diff(%{__struct__: a_struct_type} = a, %{__struct__: b_struct_type} = b) when a_struct_type === b_struct_type do
    a_keys = MapSet.new(Map.keys(a))
    b_keys = MapSet.new(Map.keys(b))

    if MapSet.equal?(a_keys, b_keys) do
      diff =
        for key <- a_keys,
            Map.fetch!(a, key) != Map.fetch!(b, key),
            into: Map.new() do
          {key, {Map.fetch!(a, key), Map.fetch!(b, key)}}
        end

      {:ok, diff}
    else
      differnce =
        MapSet.to_list(MapSet.difference(a_keys, b_keys)) ++
          MapSet.to_list(MapSet.difference(b_keys, a_keys))

      {:error, {:different_keys_with_same_struct_name_given, differnce}}
    end
  end

  def diff(%{__struct__: a_struct_type}, %{__struct__: b_struct_type}) when a_struct_type !== b_struct_type do
    {:error, {:different_struct_given, a_struct_type, b_struct_type}}
  end

  def diff(_a, %{__struct__: _}), do: {:error, {:no_struct_given, :the_first}}
  def diff(%{__struct__: _}, _b), do: {:error, {:no_struct_given, :the_second}}
  def diff(_a, _b), do: {:error, {:no_struct_given, :both}}
end
