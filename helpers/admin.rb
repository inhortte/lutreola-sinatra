module Sinatra
  module AdminHelper
    def get_properties(model)
      Object.const_get(model).send('properties').map { |p| p.name }
    end

    def property_map(props, obj)
      props.reduce({}) { |m,a| m.merge!(a => obj.send(a)) }
    end

    def menu_select(avail_menus = Menu.all, cm = nil)
      menu_id = cm.nil? ? Menu.first.id : cm.to_i # the home menu
      avail_menus.sort_by { |m| m.name }.reduce("") do |ops, menu|
        ops += "<option value=\"#{menu.name}\" #{menu_id == menu.id ? "selected=\"selected\"" : ""}>#{menu.name}</option>"
      end
    end

    # All menus excepting the one with menu_id and option values are ids
    def menu_select_by_id(menu_id)
      Menu.all(:order => [:name.asc]).select { |m| m.id != menu_id }.reduce("") do |ops, m|
        ops += "<option value=#{m.id} #{menu_id == m.id ? "selected=\"selected\"" : ""}>#{m.name}</option>"
      end
      "<option value=0>NONE</option>" + ops
    end

    def page_select(menu_id)
      Entry.all.select do |e|
        (menu_id.nil? || e.main_menu == menu_id) && e.class == Page
      end.reduce("") do |ops, e|
        ops += "<option value=#{e.id} #{(!menu_id.nil? && Menu.get(menu_id).default_page_id == e.id) ? "selected=\"selected\"" : ""}>#{e.title}</option>"
      end
    end

    def collection_select
      Collection.all(:order => [:name.asc]).reduce("") do |ops, coll|
        ops += "<option value=\"#{coll.id}\">#{coll.name}</option>"
      end 
    end

    def get_menu_titles(e)
      e.entry_menus.reduce([]) do |mts, em|
        mts = mts + [[em.menu, em.title]]
      end
    end

    def get_menu_titles_hidden_value(e)
      e.entry_menus.reduce([]) do |mthv, em|
        mthv = mthv + ["#{em.menu.name}:#{em.title}"]
      end.join(";")
    end
  end
  helpers AdminHelper
end
