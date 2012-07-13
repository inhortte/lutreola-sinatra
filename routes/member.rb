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
      redirect '/content/home'
    else
      flash[:notice] = "Something went awry."
      redirect '/member/login'
    end
  end
  get '/logout' do
    session[:id] = nil
    redirect '/content/home'
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
    redirect '/content/home'
  end
end
