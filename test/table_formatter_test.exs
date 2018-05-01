defmodule TableFormatterTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def test_data do
    [
      [ number: 23, created_at: "2018-01-01", title: "Fix windows installation"],
      [ number: 67, created_at: "2018-02-01", title: "Typo in summary"],
      [ number: 2, created_at: "2018-03-01", title: "Upgrade to 1.6"]
    ]
  end

  def headers, do: [ :number, :created_at, :title ]

  def split_data, do: TF.split_data_by_column(test_data(), headers())

  test "split_data_by_column" do
    data_split_into_columns = split_data()

    assert List.first(data_split_into_columns) == [ "23", "67", "2"]
    assert List.last(data_split_into_columns) == [ "Fix windows installation", "Typo in summary", "Upgrade to 1.6"]
  end

  test "max_widths_of" do
    widths = TF.max_widths_of(split_data())
    assert widths == [2, 10, 24]
  end

  test "format_for" do
    format = TF.format_for([2, 10, 24])
    assert format == "~-2s | ~-10s | ~-24s~n"
  end

  test "convert_column_to_row" do
    format = TF.format_for([2, 10, 24])
    row = capture_io fn ->
      TF.convert_column_to_row(split_data(), format)
    end

    assert row == """
    23 | 2018-01-01 | Fix windows installation
    67 | 2018-02-01 | Typo in summary
    2  | 2018-03-01 | Upgrade to 1.6
    """
  end

  test "print_header_seperator" do
    header_seperator = TF.print_header_seperator([2, 10, 24])
    assert header_seperator == "---+------------+-------------------------"
  end

  test "output is correct" do
    result = capture_io  fn ->
      TF.print_table_for_columns(test_data(), headers())
    end

    assert result == ""
  end
end
