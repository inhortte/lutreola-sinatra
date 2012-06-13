module Sinatra
  module AdminHelper
    def get_properties(model)
      Object.const_get(model).send('properties').map { |p| p.name }
    end

    def property_map(props, obj)
      props.reduce({}) { |m,a| m.merge!(a => obj.send(a)) }
    end

    def menu_select
      Menu.all(:order => [:name.asc]).reduce("") do |ops, menu|
        ops += "<option value=#{menu.name}>#{menu.name}</option>"
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
