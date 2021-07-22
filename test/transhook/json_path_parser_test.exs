defmodule Transhook.JSONPathParserTest do
  use Transhook.ServiceCase

  alias Transhook.Transformer.JSONPathParser

  describe("JSONPathParser.parse/1") do
    test "a single selector" do
      str = "{$.bb.cc}"

      {:ok, [match], _, _, _, _} = JSONPathParser.parse(str)

      assert match == %{begin_mark: "{", end_mark: "}", selector: "$.bb.cc"}
    end

    test "a single selector with other text" do
      str = "Foobar Zee [{$.bb.cc}] Hello World"

      {:ok, [match], _, _, _, _} = JSONPathParser.parse(str)

      assert match == %{begin_mark: "{", end_mark: "}", selector: "$.bb.cc"}
    end

    test "multiple selectors with other text" do
      str = "Foobar Zee [{$.bb.cc}] Hello World {$.ff.dd}"

      {:ok, [first_match, second_match], _, _, _, _} = JSONPathParser.parse(str)

      assert first_match == %{begin_mark: "{", end_mark: "}", selector: "$.bb.cc"}
      assert second_match == %{begin_mark: "{", end_mark: "}", selector: "$.ff.dd"}
    end

    test "without any selector but text" do
      str = "Foobar zee hahah"

      {:ok, result, _, _, _, _} = JSONPathParser.parse(str)

      assert result == []
    end

    test "empty string" do
      str = ""

      {:ok, result, _, _, _, _} = JSONPathParser.parse(str)

      assert result == []
    end
  end
end
