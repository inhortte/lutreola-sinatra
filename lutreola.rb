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

before do
  m = get_member
  if m
    if m.class == Admin && m.last_action && Time.now.to_i - m.last_action.to_i > 600
      clear_member
    else
      m.update(:last_action => Time.now)
    end
  end
end

get '/lutreola.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :"sass/lutreola"
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
  helpers Sinatra::AdminHelper
  before do
    m = get_member
    if !m || m.class != Admin
      flash[:notice] = "Oops!"
      redirect '/member/login'
    end
  end
  get { haml :"admin/map" }
  get('/map') { haml :"admin/map" }
  get('/gallery') { haml :"admin/gallery" }

  # matches /menu, /entry, /collection, /photo
  get %r{^/(\w+)$} do
    p = params[:captures][0].capitalize
    haml :"admin/#{p.downcase}", :locals => property_map(get_properties(p), Object.const_get(p).send('new'))
  end

  # matches /menu/:id, /entry/:id, /collection/:id, /photo/:id
  get %r{^/(\w+)/(\d+)$} do
    p = params[:captures][0].capitalize
    obj = Object.const_get(p).send('get', params[:captures][1])
    loc_map = {:menu => :entry_menus, :entry => :menu_titles,
      :collection => :collection_photos }
    haml :"admin/#{p.downcase}", :locals =>
      {loc_map[p.downcase.to_sym] => case p
                                     when "Menu"
                                       obj.entry_menus
                                     when "Entry"
                                       get_menu_titles(obj)
                                     when "Collection"
                                       obj.collection_photos
                                     end}.merge(property_map(get_properties(p),
                                                             obj))
  end

  post '/menu' do
    logger.info params.inspect
    if params["ordr"]
      ids = params["ordr"].split(',')
      ordr = Hash[ids.zip((1..(ids.length)).to_a)]
      params.delete("ordr")
    else
      ordr = {}
    end
    if params[:id]
      m = Menu.get(params[:id])
      m.update(params)
      flash[:notice] = "#{m.name} updated"
    else
      m = Menu.new(params)
      flash[:notice] = m.save ? "#{m.name} saved" : "Save failed"
    end
    ordr.keys.each { |k| EntryMenu.first(:menu_id => m.id, :entry_id => k).update(:ordr => ordr[k]) }
    redirect "/admin/menu/#{m.id}"
  end  

  post '/entry' do
    params.delete("menus")
    mts = params.keys.reduce({}) { |ms, k| k.to_s =~ /^mt/ ?
      ms.merge!(k => params[k]) : ms }
    mts.keys.each { |mtk| params.delete(mtk) }
    logger.info params.inspect
    logger.info mts.inspect
    if params[:id]
      e = Entry.get(params[:id])
      e.update(params)
      lemur = "updated"
    else
      if params[:url].strip.empty?
        e = Page.new(params)
      else
        e = Link.new(params)
      end
      unless e.save
        flash[:notice] = "Save failed"
        redirect "/admin/entry"
      end
      lemur = "saved"
    end
    e.entry_menus.each { |em| em.destroy }
    mts.keys.each do |k|
      EntryMenu.create!(:entry_id => e.id,
                        :menu_id => Menu.first(:name => k.to_s[2..-1]).id,
                        :title => mts[k])
    end
    flash[:notice] = "#{e.title} #{lemur}"
    redirect "/admin/entry/#{e.id}"
  end

  post '/collection' do
    logger.info params.inspect
    if params["ordr"]
      ids = params["ordr"].split(',')
      ordr = Hash[ids.zip((1..(ids.length)).to_a)]
      params.delete("ordr")
    else
      ordr = {}
    end
    if params[:id]
      m = Menu.get(params[:id])
      m.update(params)
      flash[:notice] = "#{m.name} updated"
    else
      m = Menu.new(params)
      flash[:notice] = m.save ? "#{m.name} saved" : "Save failed"
    end
    ordr.keys.each { |k| EntryMenu.first(:menu_id => m.id, :entry_id => k).update(:ordr => ordr[k]) }
    redirect "/admin/menu/#{m.id}"
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
