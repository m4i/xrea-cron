$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'cron/crontab'

crontab = <<__EOF__
# コメント
    # 先頭にスペースが入ったコメント

* * * * * foo bar baz
					
# 前後に空の行

__EOF__


describe Cron::Crontab, 'がコメント行を含んでいる場合:' do
  before do
    @lines = Cron::Crontab.parse(crontab)
  end

  it '実行する行は1行である' do
    @lines.size.should == 1
  end
end
