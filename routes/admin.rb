namespace '/admin' do
  helpers Sinatra::AdminHelper
  before do
    m = get_member
    if !m || m.class != Admin
      flash[:notice] = "Oops!"
      redirect '/member/login'
    end
  end
  get { haml :"admin/map" }
  get('/map') { haml :"admin/map" }
  get('/gallery') { haml :"admin/gallery", :locals => {:collections => Collection.all(:order => [:name.asc])} }
  get('/photos') { haml :"admin/photos", :locals => {:photos => Photo.all} }

  # matches /menu, /entry, /collection, /photo
  get %r{^/(\w+)$} do
    p = params[:captures][0].capitalize
    obj = Object.const_get(p).send('new')
    haml :"admin/#{p.downcase}", :locals => {:obj => obj}.merge(property_map(get_properties(p), obj))
  end

  # matches /menu/:id, /entry/:id, /collection/:id, /photo/:id
  get %r{^/(\w+)/(\d+)$} do
    p = params[:captures][0].capitalize
    obj = Object.const_get(p).send('get', params[:captures][1])
    loc_map = {:menu => :entry_menus, :entry => :menu_titles,
      :collection => :collection_photos, :photo => :collections }
    logger.info(property_map(get_properties(p), obj).inspect)
    haml :"admin/#{p.downcase}", :locals =>
      {:obj => obj,
      loc_map[p.downcase.to_sym] => case p
                                    when "Menu"
                                      obj.entry_menus
                                    when "Entry"
                                      get_menu_titles(obj)
                                    when "Collection"
                                      obj.collection_photos
                                    when "Photo"
                                      obj.collections
                                    end}.merge(property_map(get_properties(p),
                                                             obj))
  end

  # matches /menu, /collection
  post %r{^/(menu|collection)$} do
    logger.info params.inspect
    if params["ordr"]
      ids = params["ordr"].split(',')
      ordr = Hash[ids.zip((1..(ids.length)).to_a)]
      params.delete("ordr")
    else
      ordr = {}
    end
    p = params[:captures][0].capitalize
    params.delete("captures")
    params.delete("splat")
    if params[:id]
      obj = Object.const_get(p).send('get', params[:id])
      obj.update(params)
      flash[:notice] = "#{obj.name} updated"
    else
      obj = Object.const_get(p).send('new', params)
      flash[:notice] = obj.save ? "#{obj.name} saved" : "Save failed"
    end
    ordr.keys.each do |k|
      Object.const_get(p == "Menu" ? "EntryMenu" : "CollectionPhoto").first((p == "Menu" ? :menu_id : :collection_id) => obj.id, (p == "Menu" ? :entry_id : :photo_id) => k).update(:ordr => ordr[k])
    end
    redirect "/admin/#{p.downcase}/#{obj.id}"
  end

  post '/entry' do
    params.delete("menus")
    mts = params.keys.reduce({}) { |ms, k| k.to_s =~ /^mt/ ?
      ms.merge!(k => params[k]) : ms }
    mts.keys.each { |mtk| params.delete(mtk) }
    params["main_menu"] =
      begin
        Menu.first(:name => params["main_menu"]).id
      rescue
        Menu.first.id
      end
    if params[:id]
      e = Entry.get(params[:id])
      e.update(params)
      lemur = "updated"
    else
      if params[:url].strip.empty?
        e = Page.new(params)
      else
        e = Link.new(params)
      end
      unless e.save
        flash[:notice] = "Save failed: " +
          e.errors.full_messages.join("<br />")
        redirect "/admin/entry"
      end
      lemur = "saved"
    end
    e.entry_menus.each { |em| em.destroy }
    mts.keys.each do |k|
      EntryMenu.create!(:entry_id => e.id,
                        :menu_id => Menu.first(:name => k.to_s[2..-1]).id,
                        :title => mts[k])
    end
    flash[:notice] = "#{e.title} #{lemur}"
    redirect "/admin/entry/#{e.id}"
  end

  post '/photo' do
    params.delete("collections")
    c_keys = params.keys.select { |k| k.to_s =~ /^coll/ }
    c_ids = c_keys.map { |k| m = %r{^coll(\d+)$}.match(k); m[1].to_i }
    c_keys.each { |k| params.delete(k) }
    logger.info params.inspect
    logger.info c_ids.inspect
    if params[:id]
      p = Photo.get(params[:id])
      params.delete("image")
      p.update(params)
      lemur = "updated"
    else
      p = Photo.new(params)
      unless p.save
        flash[:notice] = "Save failed"
        redirect "/admin/photo"
      end
      lemur = "saved"
    end
    p.collection_photos.each { |cp| cp.destroy }
    c_ids.each do |id|
      CollectionPhoto.create!(:collection_id => id,
                              :photo_id => p.id)
    end
    flash[:notice] = "#{p.name} #{lemur}"
    redirect "/admin/photo/#{p.id}"
  end

  post '/arrange_gallery' do
    CollectionPhoto.destroy!
    params.delete("0")
    logger.info params.inspect
    params.keys.each do |coll_id|
      index = 0
      params[coll_id].split(',').each do |page_id|
        index = index + 1
        CollectionPhoto.create!(:collection_id => coll_id.to_i,
                                :photo_id => page_id.to_i,
                                :ordr => index)
      end
    end
    flash.now[:notice] = "Vabandage!"
    haml :flash, :layout => false
  end
end

