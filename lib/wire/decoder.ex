defmodule Wire.Decoder do

  @doc ~S"""
  Parses a binary containing 0 or more messages and
  returns a list with messages and the unparsed part of the message

  """
  @spec decode_messages(binary) :: {List.Keyword.t, binary}
  def decode_messages(binary) do
    << l :: 32-integer-big-unsigned, rest :: binary >> = binary
    cond do
      byte_size(rest) < l ->
        {[], binary}
      true ->
        decode_messages(binary, [])
    end
  end

  def decode_messages(s, acc) do
    << l :: 32-integer-big-unsigned, rest :: binary >> = s
    if byte_size(rest) < l do
      { acc, s }
    else
      { message, rest } = decode_message(s)
      if byte_size(rest) > 0 do
        decode_messages(rest, acc ++ [message])
      else
        { acc ++ [message], rest }
      end
    end
  end

  def decode_message(message) do
    << l :: 32-integer-big-unsigned, rest :: binary >> = message

    if l == 0 do
      {[type: :keep_alive], rest}
    else
      << id, rest :: binary >> = rest

      case id do
        9 ->
          << port :: 16-integer-big-unsigned, rest :: binary >> = rest
          {[type: :port, listen_port: port], rest}
        7 ->
          l2 = l - 9
          << index :: 32-integer-big-unsigned, begin :: 32-integer-big-unsigned,
             block :: binary-size(l2), rest :: binary >> = rest
          {[type: :piece, index: index, begin: begin, block: block], rest}
        id when id in [8, 6] ->
          << index   :: 32-integer-big-unsigned,
             begin   :: 32-integer-big-unsigned,
             length  :: 32-integer-big-unsigned,
             rest    :: binary >> = rest
          type = if id == 8 do :cancel else :request end
          {[type: type, index: index, begin: begin, length: length], rest}

        5 ->
          l2 = l - 1
          << field :: binary-size(l2), rest :: binary >> = rest
          {[type: :bitfield, field: field], rest}
        4 ->
          << piece_index :: 32-integer-big-unsigned, rest :: binary >> = rest
          {[type: :have, piece_index: piece_index], rest}
        3 ->
          {[type: :not_interested], rest}
        2 ->
          {[type: :interested], rest}
        1 ->
          {[type: :unchoke], rest}
        0 ->
          {[type: :choke], rest}

      end
    end
  end
end
