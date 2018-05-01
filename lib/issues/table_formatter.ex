defmodule Issues.TableFormatter do
  import Enum, only: [ map: 2, max: 1, map_join: 3]

  def print_table_for_columns(issues_list, headers) do
    data_by_columns = split_data_by_column(issues_list, headers)
    max_width_each_column = max_widths_of(data_by_columns)

    format = format_for(max_width_each_column)

    print_one_line_column(headers, format)
    IO.puts print_header_seperator(max_width_each_column)
    convert_column_to_row(data_by_columns, format)
  end

  def split_data_by_column(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  def max_widths_of(columns) do
    for column <- columns do
      column
      |> map(&String.length(&1))
      |> max
    end
  end

  def format_for(columns_width) do
    map_join(columns_width, " | ", fn width -> "~-#{width}s" end) <>  "~n"
  end

  def print_one_line_column(data, format) do
    :io.format(format, data)
  end

  def print_header_seperator(max_width_columns) do
    map_join(max_width_columns, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def convert_column_to_row(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list(&1))
    |> Enum.each(&print_one_line_column(&1, format))
  end

  def printable(row_str) when is_binary(row_str), do: row_str
  def printable(row_str), do: to_string(row_str)
end
