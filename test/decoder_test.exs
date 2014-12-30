Code.require_file "test_helper.exs", __DIR__

defmodule WireDecoderTest do
  use ExUnit.Case, async: True

  import Wire.Decoder, only: [decode_message: 1, decode_messages: 1, decode_messages: 2]

  test "parses keep_alive correctly" do
    assert decode_message(<< 0, 0, 0, 0 >>)  == {[type: :keep_alive], <<>>}
  end

  test "parses have correctly" do
    assert decode_message(<< 0, 0, 0, 5, 4, 0, 0, 0, 96, 0, 96, 3, 5>>) == {[type: :have, piece_index: 96], <<0, 96, 3, 5>>}
  end

  test "parses interested correctly" do
    assert decode_message(<< 0, 0, 0, 1, 2 >>) == {[type: :interested], <<>>}
  end

  test "parses bitfield correctly" do
    assert decode_message(<< 0, 0, 0, 6, 5, 0, 2, 4, 0, 2 >>) ==
                {[type: :bitfield, field: <<0, 2, 4, 0, 2>>], <<>>}
  end

  test "parses unchoke messages" do
    assert decode_messages(<< 0, 0, 0, 1, 1 >>) == {[[type: :unchoke]], <<>>}
  end

  test "parses several messages" do
    assert decode_messages(<< 0, 0, 0, 0, 0, 0, 0, 1, 2 >>) ==
                          {[[type: :keep_alive], [type: :interested]], <<>>}
  end

  test "parses a part of a message as rest" do
    assert decode_messages(<< 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0xf, 5 >>) ==
                          {[[type: :keep_alive], [type: :interested]], <<0, 0, 0, 0xf, 5>>}
    assert decode_messages(<< 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 >>) ==
                          {[[type: :keep_alive], [type: :keep_alive]], <<0, 0, 0, 1>>}
  end

  test "parses several messages with acc" do
    assert decode_messages(<< 0, 0, 0, 0, 0, 0, 0, 1>>, []) ==
                          {[[type: :keep_alive]], <<0, 0, 0, 1>>}
    assert decode_messages(<< 0, 0, 0, 1, 2, 0, 0, 0, 5>>, [[type: :keep_alive]]) ==
                          {[[type: :keep_alive], [type: :interested]], <<0, 0, 0, 5>>}
  end
end
