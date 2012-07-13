module Sinatra
  module GalleryHelper
    def get_collection
      session[:collection]
    end

    def set_collection(collection)
      session[:collection] = collection
    end
  end
  helpers GalleryHelper
end
