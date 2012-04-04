module Sinatra
  module DbHelper
    def get_text_from_db(page, name, *lang_debug)
      lang = if lang_debug.empty?
               get_lang
             else
               lang_debug[0]
             end
      Object.const_get(page.to_s.capitalize).first(:name => name).send(lang)
    end

    def get_paragraphs_from_db(page, name, *lang_debug)
      lang = if lang_debug.empty?
               get_lang
             else
               lang_debug[0]
             end
      Object.const_get(page.to_s.capitalize).all(:name => name, :order => [ :ordr.asc ]).map { |p| p.send(lang) }
    end

    # for photo gallery.                                                           
    def get_photos_from_db
      Photo.all(:name => "photo", :order => [ :ordr.asc ])
    end
  end
  
  helpers DbHelper
end
