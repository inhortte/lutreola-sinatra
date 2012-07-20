module Sinatra
  module GeneralHelper
    # [ title of the entry to go in the menu,
    #   link to the entry,
    #   the main menu of the entry ]
    def get_menu_options(menu_id)
      Menu.get(menu_id).entry_menus.sort_by { |em| em.ordr }.map do |em|
        entry_main_menu = if em.entry.class == Page &&
                              Menu.get(em.entry.main_menu).id != menu_id
                            Menu.get(em.entry.main_menu)
                          end
        [em.title.capitalize,
         (em.entry.class == Link ? em.entry.url : "/content/#{em.entry.id}"),
         entry_main_menu]
      end
    end

    def get_breadcrumbs
      if admin_page?
        "You are an administrator, sir."
      elsif gallery_page?
        "You are in the gallery, sir."
      else
        m = Menu.get(Entry.get(session[:current_entry]).main_menu)
        links = []
        while(!m.nil?) do
          entry_id = m.default_page_id || Entry.first(:main_menu => m.id).id
          links.unshift("<a href=\"/content/#{entry_id}\">#{m.name}</a>")
          m = m.parent
        end
        links.join(" -&gt; ")
      end
    end

    def admin_page?
      request.path_info =~ %r{^/admin}
    end

    def gallery_page?
      request.path_info =~ %r{^/gallery}
    end
  end
  helpers GeneralHelper
end
