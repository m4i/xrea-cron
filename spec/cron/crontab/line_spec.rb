$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib')
require 'cron/crontab/line'


describe Cron::Crontab::Line, 'が "* * * * * foo bar baz" の場合:' do
  before do
    @line = Cron::Crontab::Line.new('* * * * * foo bar baz')
  end

  it 'command は "foo bar baz" である' do
    @line.command.should == 'foo bar baz'
  end

  it 'どんなときでも実行する' do
    time = Time.local(2000)
    srand(0)
    100.times do |n|
      time += 60 * rand(10000)
      @line.execute?(time).should be_true
    end
  end
end
