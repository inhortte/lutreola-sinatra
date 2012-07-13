namespace '/content' do
  helpers Sinatra::LangHelper
  before do
    logger.info "PATH: #{request.path_info}"
    unless get_lang
      set_lang "en"
      redirect '/content/home'
    end
#    m = %r{^/content/(.+)$}.match(request.path_info)
#    if !m || m[1] == 'home'
#      @menu = Menu.first(:name => 'home')
#    else
#      @menu = Page.get(m[1]).main_menu
#    end
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

