module Sinatra
  module GeneralHelper
    def get_menu_options(menu_id)
      Menu.get(menu_id).entry_menus.sort_by { |em| em.ordr }.map do |em|
        [em.title.capitalize,
         (em.entry.class == Link ? em.entry.url : "/content/#{em.entry.id}")]
      end
    end

    def get_breadcrumbs
      bcs = session[:breadcrumbs]
      logger.info bcs
      bcs.reduce([]) do |ms, m|
        menu = Menu.get(m)
        page_id = menu.default_page_id.nil? ? menu.entries.select { |e| e.is_a? Page }.first.id : menu.default_page_id
        ms.push("<a href=\"/content/#{page_id}\">#{menu.name}</a>")
      end.join(" -&gt; ")
    end

    def gallery_page?
      request.path_info =~ %r{^/gallery}
    end
  end
  helpers GeneralHelper
end
