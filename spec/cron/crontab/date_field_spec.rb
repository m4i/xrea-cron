$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib')
require 'cron/crontab/date_field'


describe Cron::Crontab::DateField::Minute, 'が "*" の場合:' do
  before do
    @minute = Cron::Crontab::DateField::Minute.new('*')
  end

  it '何分だとしても実行する' do
    (0..59).each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_true
    end
  end
end


describe Cron::Crontab::DateField::Minute, 'が "24" の場合:' do
  before do
    @minute = Cron::Crontab::DateField::Minute.new('24')
  end

  it '24分のときは実行する' do
    time = Time.local(2000, 1, 1, 0, 24)
    @minute.execute?(time).should be_true
  end

  it '24分のとき以外は実行しない' do
    ((0..59).to_a - [24]).each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Minute, 'が "*/2" の場合:' do
  before do
    @minute = Cron::Crontab::DateField::Minute.new('*/2')
  end

  it '偶数分のときは実行する' do
    0.step(59, 2) do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_true
    end
  end

  it '奇数分のときは実行しない' do
    1.step(59, 2) do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Minute, 'が "10-20" の場合:' do
  before do
    @minute = Cron::Crontab::DateField::Minute.new('10-20')
  end

  targets = (10..20).to_a

  it '10分から20分のときは実行する' do
    targets.each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_true
    end
  end

  it '10分から20分のとき以外は実行しない' do
    ((0..59).to_a - targets).each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Minute, 'が "40-50/3" の場合:' do
  before do
    @minute = Cron::Crontab::DateField::Minute.new('40-50/3')
  end

  targets = [42,45,48]

  it '42,45,48分のときは実行する' do
    targets.each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_true
    end
  end

  it '42,45,48分のとき以外は実行しない' do
    ((0..59).to_a - targets).each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Minute, 'が "4,21-26/2,37-39" の場合:' do
  before do
    @minute = Cron::Crontab::DateField::Minute.new('4,21-26/2,37-39')
  end

  targets = [4,22,24,26,37,38,39]

  it '4,22,24,26,37,38,39分のときは実行する' do
    targets.each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_true
    end
  end

  it '4,22,24,26,37,38,39分のとき以外は実行しない' do
    ((0..59).to_a - targets).each do |minute|
      time = Time.local(2000, 1, 1, 0, minute)
      @minute.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Hour, 'が "12-24" の場合:' do
  it 'Cron::Crontab::DateField::ParseError が raise される' do
    lambda { Cron::Crontab::DateField::Hour.new('12-24') }.
      should raise_error(Cron::Crontab::DateField::ParseError, 'out of range - (0..23).include?(24) is false')
  end
end


describe Cron::Crontab::DateField::Month, 'が "Jun" の場合:' do
  before do
    @month = Cron::Crontab::DateField::Month.new('Jun')
  end

  targets = [6]

  it "#{targets}月のときは実行する" do
    targets.each do |month|
      time = Time.local(2000, month)
      @month.execute?(time).should be_true
    end
  end

  it "#{targets}月のとき以外は実行しない" do
    ((1..12).to_a - targets).each do |month|
      time = Time.local(2000, month)
      @month.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Month, 'が "sep" の場合:' do
  before do
    @month = Cron::Crontab::DateField::Month.new('sep')
  end

  targets = [9]

  it "#{targets}月のときは実行する" do
    targets.each do |month|
      time = Time.local(2000, month)
      @month.execute?(time).should be_true
    end
  end

  it "#{targets}月のとき以外は実行しない" do
    ((1..12).to_a - targets).each do |month|
      time = Time.local(2000, month)
      @month.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Month, 'が "DEC" の場合:' do
  before do
    @month = Cron::Crontab::DateField::Month.new('DEC')
  end

  targets = [12]

  it "#{targets}月のときは実行する" do
    targets.each do |month|
      time = Time.local(2000, month)
      @month.execute?(time).should be_true
    end
  end

  it "#{targets}月のとき以外は実行しない" do
    ((1..12).to_a - targets).each do |month|
      time = Time.local(2000, month)
      @month.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::Month, 'が "February" の場合:' do
  it 'Cron::Crontab::DateField::ParseError が raise される' do
    lambda { Cron::Crontab::DateField::Month.new('February') }.
      should raise_error(Cron::Crontab::DateField::ParseError)
  end
end


describe Cron::Crontab::DateField::Month, 'が "Mar,May" の場合:' do
  it 'Cron::Crontab::DateField::ParseError が raise される' do
    lambda { Cron::Crontab::DateField::Month.new('Mar,May') }.
      should raise_error(Cron::Crontab::DateField::ParseError)
  end
end


describe Cron::Crontab::DateField::DayOfWeek, 'が "0" の場合:' do
  before do
    @weekday = Cron::Crontab::DateField::DayOfWeek.new('0')
    @sunday  = Time.local(2000, 1, 2)
  end

  targets = [0]

  it "日曜は実行する" do
    targets.each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_true
    end
  end

  it "日曜以外は実行しない" do
    ((0..6).to_a - targets).each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::DayOfWeek, 'が "1-5" の場合:' do
  before do
    @weekday = Cron::Crontab::DateField::DayOfWeek.new('1-5')
    @sunday  = Time.local(2000, 1, 2)
  end

  targets = (1..5).to_a

  it "平日は実行する" do
    targets.each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_true
    end
  end

  it "平日以外は実行しない" do
    ((0..6).to_a - targets).each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::DayOfWeek, 'が "7" の場合:' do
  before do
    @weekday = Cron::Crontab::DateField::DayOfWeek.new('7')
    @sunday  = Time.local(2000, 1, 2)
  end

  targets = [0]

  it "日曜は実行する" do
    targets.each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_true
    end
  end

  it "日曜以外は実行しない" do
    ((0..6).to_a - targets).each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_false
    end
  end
end


describe Cron::Crontab::DateField::DayOfWeek, 'が "Mon" の場合:' do
  before do
    @weekday = Cron::Crontab::DateField::DayOfWeek.new('Mon')
    @sunday  = Time.local(2000, 1, 2)
  end

  targets = [1]

  it "月曜は実行する" do
    targets.each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_true
    end
  end

  it "月曜以外は実行しない" do
    ((0..6).to_a - targets).each do |wday|
      time = @sunday + 86400 * wday
      @weekday.execute?(time).should be_false
    end
  end
end
