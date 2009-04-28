#!/usr/bin/env ruby

require 'cgi'
require 'net/http'
require 'nkf'
require 'yaml'

config_path = File.join(File.dirname(__FILE__), 'register.yml')
config      = YAML.load_file(config_path)


params = {}

params['id']       = config['id']
params['pass']     = config['password']
params['crontab2'] = NKF.nkf('-Ws', '　　保　存　　')

30.times do |index|
  params["min#{index}"]   = (index * 2).to_s
  params["hour#{index}"]  = '*'
  params["day#{index}"]   = '*'
  params["mon#{index}"]   = '*'
  params["dow#{index}"]   = '*'
  params["shell#{index}"] = config['path']
end

body = params.map{|k,v| "#{k}=#{CGI.escape(v)}" }.join('&')


Net::HTTP.version_1_2
Net::HTTP.start(config['host']) do |http|
  p http.post('/jp/admin.cgi', body)
end
