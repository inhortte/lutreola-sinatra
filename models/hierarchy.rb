require 'dm-core'
require 'dm-migrations'

class EntryMenu
  include DataMapper::Resource

  property :ordr, Integer, :default => 1
  property :title, String, :length => 20
  belongs_to :menu, :key => true
  belongs_to :entry, :key => true
end

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 20, :required => true, :unique => true
  property :default_page_id, Integer

  has n, :entry_menus
  has n, :entries, :through => :entry_menu

  def default_page
    Page.get(self.default_page_id)
  end
end

class Entry
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :required => true
  property :type, Discriminator
  property :role, String, :length => 20
  property :main_menu, Integer

  property :url, String
  property :en, Text
  property :ee, Text

  has n, :entry_menus
  has n, :menus, :through => :entry_menu
end

class Page < Entry; end
class Link < Entry; end
