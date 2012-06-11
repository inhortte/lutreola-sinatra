require 'dm-core'
require 'dm-migrations'

class EntryMenu
  include DataMapper::Resource

  property :ordr,    Integer
  belongs_to :menu, :key => true
  belongs_to :entry, :key => true
end

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 20, :required => true, :unique => true
  property :default_page_id, Integer

  has n, :entries, :through => :entry_menu

  def default_page
    Page.get(self.default_page_id)
  end
end

class Entry
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :required => true
  property :menu_title, String, :length => 20
  property :type, Discriminator
  property :role, String, :length => 20

  property :url, String
  property :en, Text
  property :ee, Text

  has n, :menus, :through => :entry_menu

  before :save, :establish_menu_title

  private
  def establish_menu_title
    if self.menu_title.nil? || self.menu_title.empty?
      self.menu_title = self.title.downcase
    end
  end
end

class Page < Entry; end
class Link < Entry; end
