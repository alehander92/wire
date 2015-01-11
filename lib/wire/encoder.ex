defmodule Wire.Encoder do

  def encode(type: :handshake, extensions: extensions, info_hash: info_hash,
             peer_id: peer_id) do
    <<19                    :: size(8),
      "BitTorrent protocol" :: binary,
      extensions            :: binary-size(8),
      info_hash             :: binary-size(20),
      peer_id               :: binary-size(20)>>
  end

  def encode(type: :ltep, ext_msg_id: ext_msg_id, msg: msg) when is_map(msg) do
    bencoded_msg = Bencodex.encode(msg)
    length       = byte_size(bencoded_msg) + 2

    << length       :: 32-integer-big-unsigned,
       20           :: size(8),
       ext_msg_id   :: size(8),
       bencoded_msg :: binary >>
  end


  def encode(type: :port, listen_port: listen_port) do
    << 0, 0, 0, 3, listen_port :: 16-integer-big-unsigned, 0 >>
  end

  def encode(type: request_or_cancel, index: index, begin: begin, length: length) when request_or_cancel in [:cancel, :request] do
    a = if request_or_cancel == :cancel do 8 else 6 end

    << 0, 0, 0, 0xd, a,
       index :: 32-integer-big-unsigned,
       begin :: 32-integer-big-unsigned,
       length  :: 32-integer-big-unsigned >>
  end

  def encode(type: :piece, index: index, begin: begin, block: block) do
    << (9 + byte_size(block)) :: 32-integer-big-unsigned, 8, index :: 32-integer-big-unsigned, begin :: 32-integer-big-unsigned,
       block :: binary >>
  end

  def encode(type: :bitfield, field: field) do
    << (1 + byte_size(field)) :: 32-integer-big-unsigned, 5, field :: binary>>
  end

  def encode(type: :have, piece_index: piece_index) do
    << 0, 0, 0, 5, 4, piece_index :: 32-integer-big-unsigned >>
  end

  def encode(type: :not_interested) do
    << 0, 0, 0, 1, 3 >>
  end

  def encode(type: :interested) do
    << 0, 0, 0, 1, 2 >>
  end

  def encode(type: :unchoke) do
    << 0, 0, 0, 1, 1 >>
  end

  def encode(type: :choke) do
    << 0, 0, 0, 1, 0 >>
  end

  def encode(type: :keep_alive) do
    << 0, 0, 0, 0 >>
  end
end
