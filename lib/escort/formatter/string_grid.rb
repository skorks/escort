module Escort
  module Formatter
    class StringGrid
      DEFAULT_WIDTH = 80

      attr_reader :column_count, :width
      attr_accessor :rows

      def initialize(options = {}, &block)
        @width = options[:width] || DEFAULT_WIDTH
        @column_count = options[:columns] || 3
        @rows = []
        block.call(self) if block_given?
      end

      def row(*column_values)
        while column_values.size < @column_count
          column_values << ''
        end
        rows << column_values.map(&:to_s)
      end

      def to_s
        buffer = []
        rows.each do |cells|
          virtual_row = normalize_virtual_row(virtual_row_for(cells))
          physical_row_count_for(virtual_row).times do |physical_count|
            physical_row = format_physical_row_values(physical_row_for(virtual_row, physical_count))
            buffer << physical_row.join("").chomp
          end
        end
        buffer.join("\n")
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
        width = fair_column_width(column_index)
        if column_index == column_count - 1
          width = last_column_width
        end
        width
      end

      def fair_column_width(index)
        width = values_in_column(index).map(&:length).max
        width = width + 1
        width > max_column_width ? max_column_width : width
      end

      def last_column_width
        full_fair_column_width = max_column_width * column_count + max_column_width_remainder
        all_but_last_fair_column_width = 0
        (column_count - 1).times do |index|
          all_but_last_fair_column_width += fair_column_width(index)
        end
        full_fair_column_width - all_but_last_fair_column_width
      end

      def values_in_column(column_index)
        rows.map{|cells| cells[column_index]}
      end

      def max_column_width
        width/column_count
      end

      def max_column_width_remainder
        width%column_count
      end

      def cell_value(value, column_index)
        sprintf("%-#{column_width(column_index)}s", value)
      end
    end
  end
end
