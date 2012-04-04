module Sinatra
  module FormattingHelper
    def header_hlavni(name, *more)
      res = "<h3>#{get_text_from_db(:menu, name)}</h3>"
      unless more.empty?
        more.each { |s| res << s }
      end
      res << "<hr />"
      res
    end

    def stretch_text(s)
      s.split('').join('&nbsp;')
    end

    def para_wrap(text)
      "<p>#{text}</p>"
    end

    def many_para_wrap(col)
      col.select { |p| !p.nil? }.map { |p| para_wrap p }.inject("") do |r, p|
        r << p
      end
    end

    # photo gallery                                                                
    def organise_photos(col)
      col.sort_by { |p| p.ordr }.inject([]) do |res, photo|
        if photo.show
          m = %r{_(\d+x\d+)\.}.match(photo.thumb)
          res << { :thumb => photo.thumb, :photo => photo.photo,
            :desc => photo.send(get_lang), :dim => m[1] }
        else
          res
        end
      end.sort_by { |p| p[:dim] }.reverse
    end

    def thumb_wrap(photo_hash)
      m = %r{^(.+)_}.match(photo_hash[:thumb])
      "<div class=\"thumbnail\" id=\"thumb#{m[1]}\"><a href=\"#\"><img src=\"#{photo_url(photo_hash[:thumb])}\" alt=\"#{photo_hash[:desc]}\" /></a></div>"
    end

    def many_thumb_wrap(n, col)
      res = '<div id="photo_gallery">'
      organise_photos(col).map { |p| thumb_wrap(p) }.each_slice(n) do |ps|
        ps.each { |p| res << p }
        res << '<br class="clear"><br class="clear">'
      end
      res << '</div>'
    end
  end
  
  helpers FormattingHelper
end
