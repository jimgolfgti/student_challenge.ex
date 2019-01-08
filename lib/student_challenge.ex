defmodule StudentChallenge do
  alias StudentChallenge.{Basket, StockItem}

  @moduledoc """
  Documentation for StudentChallenge.
  """

  @doc """
  Student Challenge.

  ## Examples

      iex> StudentChallenge.calculate_basket ""
      %{ total: 0.0, delivery_charge: 0.0 }

      iex> StudentChallenge.calculate_basket "A"
      %{ total: 8.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "B"
      %{ total: 12.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "C"
      %{ total: 4.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "D"
      %{ total: 7.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "E"
      %{ total: 5.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "BB"
      %{ total: 20.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "BBB"
      %{ total: 32.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "BBBB"
      %{ total: 40.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "CCC"
      %{ total: 10.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "CCCC"
      %{ total: 14.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "DD"
      %{ total: 7.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "DDD"
      %{ total: 14.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "EE"
      %{ total: 10.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "EEE"
      %{ total: 10.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "EEEE"
      %{ total: 15.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "DDDDDDDDDDDDDD"
      %{ total: 49.0, delivery_charge: 7.0 }

      iex> StudentChallenge.calculate_basket "BBBBCCC"
      %{ total: 50.0, delivery_charge: 0.0 }

      iex> StudentChallenge.calculate_basket "ABBCCCDDEE"
      %{ total: 55.0, delivery_charge: 0.0 }

      iex> StudentChallenge.calculate_basket "EDCBAEDCBC"
      %{ total: 55.0, delivery_charge: 0.0 }
  """
  def calculate_basket(example) do
    basket = create_basket(%{
      "A": %StockItem{id: "A", ordinary_price: 8.0},
      "B": %StockItem{id: "B", ordinary_price: 12.0, discount_quantity: 2, discount_price: 20.0},
      "C": %StockItem{id: "C", ordinary_price: 4.0, discount_quantity: 3, discount_price: 10.0},
      "D": %StockItem{id: "D", ordinary_price: 7.0, discount_quantity: 2, discount_price: 7.0},
      "E": %StockItem{id: "E", ordinary_price: 5.0, discount_quantity: 3, discount_price: 10.0}
    })
    example
    |> String.codepoints
    |> Enum.reduce(basket, fn item, acc -> add_to_basket(acc, item) end)
    |> calculate_total_price
  end

  def create_basket(inventory) do
    %Basket{inventory: inventory}
  end

  def add_to_basket(basket, item) do
    {_, updated_items} = Map.get_and_update basket.items, item, fn current ->
      quantity = current || 0
      {current, quantity + 1}
    end
    %{basket | items: updated_items}
  end

  def calculate_total_price(%Basket{items: items}) when items == %{} do
    %{total: 0.0, delivery_charge: 0.0}
  end
  def calculate_total_price(%Basket{items: items, inventory: inventory}) do
    total = Enum.reduce items, 0.0, fn {id, quantity}, acc ->
      acc + calculate_price_for_items(quantity, Map.get(inventory, String.to_atom(id)))
    end
    %{
      total: total,
      delivery_charge: calculate_delivery(total)
    }
  end

  defp calculate_price_for_items(quantity, %StockItem{ordinary_price: ordinary_price, discount_quantity: discount_quantity})
    when discount_quantity == 0 or quantity < discount_quantity do
    ordinary_price * quantity
  end
  defp calculate_price_for_items(quantity, %StockItem{ordinary_price: ordinary_price, discount_quantity: discount_quantity, discount_price: discount_price}) do
    discount_price * div(quantity, discount_quantity) + ordinary_price * rem(quantity, discount_quantity)
  end

  defp calculate_delivery(total) when total >= 50.0, do: 0.0
  defp calculate_delivery(_total), do: 7.0
end
