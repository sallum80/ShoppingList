defmodule ShoppingList.Helper do
  @moduledoc """
    Módulo de apoio
  """

  # Transforma um mapa de strings em um mapa de átomos
  def atomify_map(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, new_map ->
      cond do
        is_binary(key) ->
          Map.put(new_map, String.to_atom(key), atomify_map(value))

        true ->
          Map.put(new_map, key, atomify_map(value))
      end
    end)
  end

  def atomify_map(other), do: other
end
