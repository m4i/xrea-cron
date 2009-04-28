#!/usr/bin/ruby -w

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'cron'

path = File.expand_path('~/.crontab')

t = Thread.new { Cron.run(path) if File.exist?(path) }
sleep 60
Cron.run(path) if File.exist?(path)
t.join
