module Cron
  module Crontab
    class MustNotHappen < Exception; end
    class ParseError < StandardError; end

    require 'cron/crontab/line'

    def parse(string)
      lines = []
      string.each_line do |line|
        next if line =~ /^\s*(?:#|$)/
        lines << Line.new(line)
      end
      lines
    end
    module_function :parse
  end
end
