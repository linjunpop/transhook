defmodule Transhook.Transformer.JSONPathParser do
  import NimbleParsec

  other_string = utf8_string([not: ?{, not: ?}], min: 0)

  begin_mark = string("{") |> unwrap_and_tag(:begin_mark)
  end_mark = string("}") |> unwrap_and_tag(:end_mark)

  json_path_selector =
    string("$")
    |> utf8_string([not: ?}], min: 1)
    |> reduce({Enum, :join, [""]})
    |> unwrap_and_tag(:selector)

  string_with_json_path =
    repeat(
      optional(ignore(other_string))
      |> concat(begin_mark)
      |> concat(json_path_selector)
      |> concat(end_mark)
      |> optional(ignore(other_string))
      |> reduce({Enum, :into, [%{}]})
    )
    |> eos

  maybe_string_with_json_path =
    choice([
      string_with_json_path,
      ignore(other_string)
    ])

  defparsec(:parse, maybe_string_with_json_path, debug: false)
end
