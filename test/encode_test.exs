Code.require_file "test_helper.exs", __DIR__

defmodule WireEncoderTest do
  use ExUnit.Case, async: True

  import Wire.Encoder, only: [encode: 1]

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
end

