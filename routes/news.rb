namespace '/news' do
  helpers Sinatra::LangHelper
  helpers Sinatra::TwitterHelper
  before do 
    unless get_lang
      set_lang "en"
      redirect '/content/home'
    end
    @menu
  end
  get { haml :news }
end
