require 'cron/crontab'
require 'cron/crontab/date_field'

module Cron
  module Crontab
    class Line
      class ParseError < Crontab::ParseError; end

      attr_reader :command

      def initialize(line)
        unless match = /^#{'(\S+)\s+' * 5}(\S.*)$/.match(line.strip)
          raise ParseError
        end

        fields = match.captures

        @date_fields = %w( Minute Hour Day Month DayOfWeek ).map do |klass|
          DateField.const_get(klass).new(fields.shift)
        end

        @command = fields.shift
      end

      def execute?(time)
        @date_fields.all? do |date_field|
          date_field.execute?(time)
        end
      end
    end
  end
end
