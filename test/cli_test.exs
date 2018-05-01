defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1,
                             sort_into_ascending_order: 1,
                             convert_list_to_map: 1 ]

  test ":help returned by parsing --h or --help" do
    assert parse_args(["-h"]) == :help
    assert parse_args(["-help", "anything"]) == :help
  end

  test "returns 3 values when given 3 values" do
    assert parse_args(["user", "this project", "3"]) == { "user", "this project", 3}
  end

  test "returns 3 values when given 2 values" do
    assert parse_args(["user", "that project"]) == { "user", "that project", 4}
  end

  test "sorting created_at in the correct order" do
    result_list = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result_list, do: issue["created_at"]
    assert issues == ["a", "b", "c"]
  end

  defp fake_created_at_list(list) do
    data = for value <- list,
           do: [{"created_at", value}, {"other_value", "xxx"}]
    convert_list_to_map(data)
  end
end
