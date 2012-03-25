require 'rubygems'

%w(sinatra rack-flash dm-core dm-migrations dm-mysql-adapter haml logger bluecloth).each { |gem| require gem }

# helpers go here
helpers = Dir.entries('./helpers').select { |h| h =~ /.rb$/ }
helpers.each do |helper|
  require File.join('./helpers', helper)
end

# models go here
%{pages.rb}.each { |model| require "./models/#{model}" }

require 'sinatra/reloader' if development?

set :sessions, true
set :show_exceptions, false
use Rack::Flash

configure do
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :static, :true
  set :public, Proc.new { File.join(root, "public") }
  LOGGER = Logger.new('lutreola.log')
end

DataMapper.setup(:default, 'mysql://localhost/lutreola')

helpers.each do |helper|
  m = /^(.+)\.rb$/.match(helper)
  if m
    eval("helpers Sinatra::#{m[1].capitalize + 'Helper'}")
  end
end

