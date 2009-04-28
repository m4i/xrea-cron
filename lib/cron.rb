require 'cron/crontab'

module Cron
  class << self
    def run(path, time = Time.now)
      Crontab.parse(File.read(path)).each do |line|
        execute(line, time)
      end
    end

    private
      def execute(line, time)
        execute!(line) if line.execute?(time)
      end

      def execute!(line)
        fork { exec line.command }
      end
  end
end
