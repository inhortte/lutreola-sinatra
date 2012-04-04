require 'rubygems'

%w(sinatra dm-core dm-migrations dm-mysql-adapter haml logger bluecloth).each { |gem| require gem }

# helpers go here
helpers = Dir.entries('./helpers').select { |h| h =~ /.rb$/ }
helpers.each do |helper|
  require File.join('./helpers', helper)
end

# models go here
%{pages.rb}.each { |model| require "./models/#{model}" }

require 'sinatra/reloader' if development?
require 'sinatra/flash'

set :sessions, true
set :show_exceptions, true

configure do
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)
  set :static, :true
  set :public_folder, Proc.new { File.join(root, "public") }
  LOGGER = Logger.new('lutreola.log')
end

DataMapper.setup(:default, 'mysql://localhost/lutreola')
DataMapper.repository(:default).adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::Underscored

helpers.each do |helper|
  m = /^(.+)\.rb$/.match(helper)
  if m
    eval("helpers Sinatra::#{m[1].capitalize + 'Helper'}")
  end
end

before do
  logger.info "PATH: #{request.path_info}"
  m = %r{^(/\w+)}.match(request.path_info)
  unless get_lang
    set_lang "ee"
    redirect m[1]
  end
end

get '/' do
  redirect '/home'
end

get '/home' do
  haml :home, :layout => false
end

get '/lang/:jazyk/:page' do
  set_lang params[:jazyk]
  redirect "/#{params[:page]}"
end

get '/news' do
  haml :templated, :locals => { :page_name => "news" }
end

get '/fl' do
  haml :templated, :locals => { :page_name => "fl" }
end

get '/mission' do
  haml :templated, :locals => { :page_name => "mission" }
end

get '/photo' do
  haml :photo_gallery
end

