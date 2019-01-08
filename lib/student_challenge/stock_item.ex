defmodule StudentChallenge.StockItem do
  @enforce_keys [:id, :ordinary_price]
  defstruct id: nil, ordinary_price: 0.0, discount_quantity: 0, discount_price: 0.0
end
