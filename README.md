Wire
====

[![Build Status](https://travis-ci.org/alehander42/wire.svg)](https://travis-ci.org/alehander42/wire/)

Wire is an elixir package for decoding and encoding
bittorrent peer wire protocol messages.


A message is represented in the library as a keyword list with
`:type`: the type of the message (`:keep_alive`, :`not_interested`, etc)
and the other fields of the message, e.g.

```elixir
h = [type: :have, piece_index: 4]
```

```elixir

Wire.encode [type: :interested] # <<0, 0, 0, 1, 2>>
Wire.encode [type: :bitfield, field: <<0, 4>>] # <<0, 0, 0, 3, 5, 0, 4>>
```

`decode_messages` decodes a binary containing 0 or more messages and
returns a list of messages and the remaining bytes

```elixir


Wire.decode_messages(<<0, 0, 0, 6, 5, 0, 2, 4, 3, 1>>)
# {[[type: :bitfield, field: <<0, 2, 4, 3, 1>>]], <<>>}
Wire.decode_messages(<< 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0xf, 5 >>)
# {[[type: :keep_alive], [type: :interested]], <<0, 0, 0, 0xf, 5>>})


```

## Install

Add to your mix.exs deps

```elixir
{:wire, "~> 0.2.0"}
```

## Development

Built and maintained by Alexander Ivanov, with substantial contributions by [Florian Adamsky](https://github.com/cit)

## LICENSE

MIT

## Copyright

Copyright (c) 2014-2015 Alexander Ivanov. See [LICENSE](LICENSE) for further details




