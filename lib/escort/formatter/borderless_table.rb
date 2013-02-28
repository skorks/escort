module Escort
  module Formatter
    class BorderlessTable
      attr_reader :column_count, :formatter
      attr_accessor :rows

      def initialize(formatter, options = {})
        @formatter = formatter
        @column_count = options[:columns] || 3
        @rows = []
      end

      def row(*column_values)
        rows << column_values.map(&:to_s)
        #TODO raise error if column values size doesn't match columns
      end

      def output(&block)
        block.call(self)

        rows.each do |cells|
          virtual_row = normalize_virtual_row(virtual_row_for(cells))
          physical_row_count_for(virtual_row).times do |physical_count|
            physical_row = format_physical_row_values(physical_row_for(virtual_row, physical_count))
            formatter.put physical_row.join("").chomp, :newlines => 1
          end
        end
      end

      private

      def format_physical_row_values(physical_row)
        physical_row.each_with_index.map do |value, index|
          cell_value(value, index)
        end
      end

      def physical_row_for(virtual_row, index)
        virtual_row.map {|physical| physical[index]}
      end

      def virtual_row_for(column_values)
        virtual_row = []
        column_values.each_with_index do |cell, index|
          virtual_row << Escort::Formatter::StringSplitter.new(column_width(index) - 1).split(cell)
        end
        normalize_virtual_row(virtual_row)
      end

      def normalize_virtual_row(virtual_row)
        virtual_row.map do |physical|
          while physical.size < physical_row_count_for(virtual_row)
            physical << ""
          end
          physical
        end
      end

      def physical_row_count_for(virtual_row)
        virtual_row.map {|physical| physical.size}.max
      end

      def column_width(column_index)
        #TODO raise error if index out of bounds
        width = fair_column_width(column_index)
        if column_index == column_count - 1
          width = last_column_width
        end
        width
      end

      def fair_column_width(index)
        #TODO raise error if index out of bounds
        width = values_in_column(index).map(&:length).max
        width = width + 1
        width > max_column_width ? max_column_width : width
      end

      def last_column_width
        full_fair_column_width = max_column_width * column_count
        all_but_last_fair_column_width = 0
        (column_count - 1).times do |index|
          all_but_last_fair_column_width += fair_column_width(index)
        end
        full_fair_column_width - all_but_last_fair_column_width
      end

      def values_in_column(column_index)
        #TODO raise error if index out of bounds
        rows.map{|cells| cells[column_index]}
      end

      def max_column_width
        (formatter.terminal_columns - 1 - formatter.current_indent_string.length)/column_count
      end

      def cell_value(value, column_index)
        sprintf("%-#{column_width(column_index)}s", value.strip)
      end
    end
  end
end
