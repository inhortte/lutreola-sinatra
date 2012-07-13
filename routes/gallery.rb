namespace '/gallery' do
  helpers Sinatra::GalleryHelper
  before do
    unless get_collection
      set_collection 0
    end
  end
  get { haml :gallery, :locals => { :photos => Photo.all } }
end
