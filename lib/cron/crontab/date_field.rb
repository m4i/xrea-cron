require 'cron/crontab'

module Cron
  module Crontab
    module DateField
      class ParseError < Crontab::ParseError; end

      class Base
        class << self
          def min(min = nil)
            min ? (@min = min) : @min
          end

          def max(max = nil)
            max ? (@max = max) : @max
          end

          def method(method = nil)
            method ? (@method = method) : @method
          end

          def valid_regex
            @valid_regex ||=
              (const_defined?(:VALID_REGEX) ?  self : superclass)::VALID_REGEX
          end
        end

        number = '(\d+)'
        single = number
        range  = "#{number}-#{number}(?:/#{number})?"
        every  = "\\*(?:/#{number})?"
        part   = "(?:#{single}|#{range}|#{every})"

        SINGLE_REGEX = /^#{single}$/
        RANGE_REGEX  = /^#{range}$/
        EVERY_REGEX  = /^#{every}$/
        VALID_REGEX  = /^#{part}(?:,#{part})*$/

        def initialize(value)
          @value = value

          raise ParseError unless valid?
          @targets = parse
        end

        def execute?(time)
          @targets.include?(time.send(self.class.method))
        end

        private
          def min; self.class.min; end
          def max; self.class.max; end

          def valid?
            !!(self.class.valid_regex =~ @value)
          end

          def parse
            targets = []

            @value.split(',').each do |part|
              matched = %w( single range every name ).any? do |match_method|
                if result = send("match_#{match_method}", part)
                  targets.concat(result)
                  true
                end
              end
              raise MustNotHappen unless matched
            end

            targets.uniq.sort
          end

          def match_single(part)
            if SINGLE_REGEX =~ part
              check_number($~)
              [$1.to_i]
            end
          end

          def match_range(part)
            if RANGE_REGEX =~ part
              check_number($~)
              range = $1.to_i .. $2.to_i
              $3 ? apply_step(range, $3.to_i) : range.to_a
            end
          end

          def match_every(part)
            if EVERY_REGEX =~ part
              check_number($~)
              range = min .. max
              $1 ? apply_step(range, $1.to_i) : range.to_a
            end
          end

          def match_name(part)
            raise MustNotHappen
          end

          def check_number(match_data)
            match_data.captures.each do |number|
              next unless number
              number = number.to_i

              unless valid_number?(number)
                message = 'out of range - (%d..%d).include?(%d) is false' % [min, max, number]
                raise ParseError, message
              end
            end
          end

          def valid_number?(number)
            (min .. max).include?(number)
          end

          def apply_step(range, step)
            range.select do |number|
              number if (number % step).zero?
            end
          end
      end


      class Minute < Base
        min    0
        max    59
        method :min
      end

      class Hour < Base
        min    0
        max    23
        method :hour
      end

      class Day < Base
        min    1
        max    31
        method :day
      end

      class Month < Base
        min    1
        max    12
        method :month

        month_names = %w( jan feb mar apr may jun jul aug sep oct nov dec )
        @@months    = Hash[*month_names.zip((1..12).to_a).flatten]
        NAME_REGEX  = /^(#{month_names.join('|')})$/i
        VALID_REGEX = Regexp.union(Base::VALID_REGEX, NAME_REGEX)

        private
          def match_name(part)
            if NAME_REGEX =~ part
              unless number = @@months[$1.downcase]
                raise ParseError
              end
              [number]
            end
          end
      end

      class DayOfWeek < Base
        min    0
        max    7
        method :wday

        day_names_of_week = %w( sun mon tue wed thu fri sat )
        @@days_of_week    = Hash[*day_names_of_week.zip((0..6).to_a).flatten]
        NAME_REGEX        = /^(#{day_names_of_week.join('|')})$/i
        VALID_REGEX       = Regexp.union(Base::VALID_REGEX, NAME_REGEX)

        private
          def parse
            targets = super
            if targets.delete(7) && !targets.include?(0)
              targets.unshift(0)
            end
            targets
          end

          def match_name(part)
            if NAME_REGEX =~ part
              unless number = @@days_of_week[$1.downcase]
                raise ParseError
              end
              [number]
            end
          end
      end
    end
  end
end
