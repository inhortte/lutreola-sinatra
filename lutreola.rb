require 'rubygems'
require 'bundler'
Bundler.require

# helpers go here
helpers = Dir.entries('./helpers').select { |h| h =~ /.rb$/ }
helpers.each do |helper|
  require File.join('./helpers', helper)
end

# models go here
%w{hierarchy.rb user.rb}.each { |model| require "./models/#{model}" }

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

before do
  m = get_member
  if m
    if m.class == Admin && Time.now.to_i - m.last_action.to_i > 600
      clear_member
    else
      m.update(:last_action => Time.now)
    end
  end
end

namespace '/member' do
  helpers Sinatra::AuthenticationHelper
  before do
    m = get_member
    if !m && request.path_info !~ %r{^/member/(login|signup|confirm)$}
      flash[:notice] = "You are not logged in."
      redirect '/member/login'
    end
  end

  get('/login') { haml :login }
  post '/login' do
    if m = authenticate(params[:username], params[:password])
      flash[:notice] = "Logged in."
      session[:id] = m.id
      redirect '/home'
    else
      flash[:notice] = "Something went awry."
      redirect '/member/login'
    end
  end
  get '/logout' do
    session[:id] = nil
    redirect '/home'
  end

  get('/signup') { haml :signup }
  post '/signup' do
    logger.info "params: " + params.inspect
    m = Member.new(params)
    if m.save
      flash[:notice] = "Created."
      haml :confirm, :locals => { :auth_token => m.auth_token }
    else
      flash[:notice] = "There was a problem."
      redirect "/member/signup"
    end
  end

  get '/confirm/:token' do
    m = Member.first(:auth_token => params[:token])
    if m
      flash[:notice] = "You are now a lutreola."
      m.update(:active => true)
    else
      flash[:notice] = "That wasn't appropriate."
    end
    redirect '/home'
  end
end

namespace '/admin' do
  before do
    m = get_member
    if !m || m.class != Admin
      flash[:notice] = "Oops!"
      redirect '/member/login'
    end
  end
end

namespace '/home' do
  helpers Sinatra::LangHelper
  before do
    logger.info "PATH: #{request.path_info}"
#    m = %r{^(/\w+)}.match(request.path_info)
    unless get_lang
      set_lang "ee"
      redirect '/home'
    end
  end
  get { haml :home }
end

=begin
get '/' do
  redirect '/home'
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
=end
