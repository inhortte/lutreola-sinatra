namespace '/gallery' do
  helpers Sinatra::GalleryHelper
  before do
    unless get_lang
      set_lang "en"
      redirect '/content/home'
    end
    unless get_collection
      set_collection 0
    end
  end
  get { haml :gallery }
  get '/collection/:id' do
    photos = if params[:id] == '0'
               Photo.all
             elsif params[:id] == '1'
               Collection.first.photos
             else
               Collection.get(params[:id]).photos
             end
    photos.map do |p|
      { :url => p.image.url, :thumb => p.image.versions[:thumb].url,
        :name => p.name, :en => p.en, :ee => p.ee }
    end.to_json
  end
end
