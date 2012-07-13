require 'rubygems'
require 'bundler'
Bundler.require

# helpers go here
helpers = Dir.entries('./helpers').select { |h| h =~ /.rb$/ }
helpers.each do |helper|
  require File.join('./helpers', helper)
end

# models go here
%w{hierarchy.rb user.rb gallery.rb}.each { |model| require "./models/#{model}" }

enable :sessions
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
DataMapper.finalize

helpers Sinatra::MemberHelper
helpers Sinatra::GeneralHelper

before do
  m = get_member
  if m
    if m.class == Admin && m.last_action && Time.now.to_i - m.last_action.to_i > 600
      clear_member
    else
      m.update(:last_action => Time.now)
    end
  end
  if !session[:breadcrumbs]
    session[:breadcrumbs] = [Menu.first(:name => 'home').id]
  end
end

# global routes
get '/clear' do
  session.clear
end

get '/lutreola.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :"sass/lutreola"
end

get '/flash' do
  haml :flash, :layout => false
end

get '/' do
  redirect '/content/home'
end

# namespaced routes
require "./routes/member.rb"
require "./routes/admin.rb"
require "./routes/content.rb"
require "./routes/gallery.rb"

