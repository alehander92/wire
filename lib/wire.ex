defmodule Wire do
  defdelegate encode(message), to: Wire.Encoder
  defdelegate decode_messages(message), to: Wire.Decoder
  defdelegate decode_message(message), to: Wire.Decoder
end


