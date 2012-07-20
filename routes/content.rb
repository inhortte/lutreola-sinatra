namespace '/content' do
  helpers Sinatra::LangHelper
  helpers Sinatra::TwitterHelper
  before do
    logger.info "PATH: #{request.path_info}"
    unless session[:current_entry]
      session[:current_entry] = Entry.first.id
    end
    unless get_lang
      set_lang "en"
      redirect '/content/home'
    end
    m = %r{^/content/(\d+)}.match(request.path_info)
    if m
      session[:current_entry] = m[1].to_i
      logger.info "Current entry: #{session[:current_entry]}"
    end
  end
  get { redirect '/content/home' }
  get('/home') { @menu = Menu.first(:name => 'home'); haml :home }
  get %r{^/(\d+)$} do
    p = Page.get(params[:captures][0])
    logger.info p.inspect
    @menu = Menu.get(p.main_menu)
    @content = BlueCloth.new(p.send(get_lang)).to_html
    haml :page
  end
end

