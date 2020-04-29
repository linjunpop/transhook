defmodule Transhook.Webhook.EndpointGenerator do
  @length 13

  @spec generate :: binary
  def generate do
    :crypto.strong_rand_bytes(@length)
    |> Base.url_encode64()
    |> binary_part(0, @length)
  end
end
