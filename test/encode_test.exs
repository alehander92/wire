Code.require_file "test_helper.exs", __DIR__

defmodule WireEncoderTest do
  use ExUnit.Case, async: True

  import Wire.Encoder, only: [encode: 1]

  test "converts ltep correctly" do
    result = <<0, 0, 0, 14, 20, 0, 100, 51, 58, 102, 111, 111, 51, 58, 98, 97, 114, 101>>

    assert encode(type: :ltep, ext_msg_id: 0, msg: %{"foo" => "bar"}) == result
  end

  test "converts port correctly" do
    assert encode(type: :port, listen_port: 80) ==
           << 0, 0, 0, 3, 0, 80, 0 >>
  end

  test "converts cancel correctly" do
    assert encode(type: :cancel, index: 2, begin: 0, length: 4) ==
           << 0, 0, 0, 0xd, 8, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 4 >>
  end

  test "converts request correctly" do
    assert encode(type: :request, index: 2, begin: 0, length: 4) ==
           << 0, 0, 0, 0xd, 6, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 4 >>
  end

  test "converts bitfield correctly" do
    assert encode(type: :bitfield, field: << 0 >>) ==
           << 0, 0, 0, 2, 5, 0 >>
  end

  test "converts have correctly" do
    assert encode(type: :have, piece_index: 22) ==
      << 0, 0, 0, 5, 4, 0, 0, 0, 22 >>
  end

  test "converts interested correctly" do
    assert encode(type: :interested) == << 0, 0, 0, 1, 2 >>
  end

  test "converts handshake correctly" do
    extensions = <<0,0,0,0,0,0,0,0>>
    peer_id    = "ffffffffffffffffffff"
    info_hash  = "eeeeeeeeeeeeeeeeeeee"

    result = <<19, 66, 105, 116, 84, 111, 114, 114, 101, 110, 116, 32, 112, 114, 111, 116, 111, 99, 111, 108, 0, 0, 0, 0, 0, 0, 0, 0>> <> info_hash <> peer_id

    assert encode(type: :handshake, extensions: extensions, info_hash: info_hash, peer_id: peer_id) == result
  end
end
