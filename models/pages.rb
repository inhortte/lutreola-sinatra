require 'dm-core'
require 'dm-migrations'

pages = %w(news fl mission contact who obj act part cb eep study husb eepfac memb species links)

pages.each do |page|
  klass = Object.const_set(page.capitalize, Class.new)
  klass.class_eval do
    include DataMapper::Resource

#    property :id, Serial
    property :name, String, :length => 20, :required => true
    property :ordr, Integer
    property :en, DataMapper::Property::Text
    property :ee, DataMapper::Property::Text
  end
end

class Photo
  include DataMapper::Resource

#  property :id, Serial
  property :name, String, :length => 20, :required => true
  property :ordr, Integer
  property :show, Boolean, :default => true, :required => true
  property :thumb, String, :length => 255, :required => true
  property :photo, String, :length => 255, :required => true
  property :en, Text
  property :ee, Text
end

class Sidebar
  include DataMapper::Resource

#  property :id, Serial
  property :name, String, :length => 20, :required => true
  property :en, Text
  property :ee, Text
end

class Menu
  include DataMapper::Resource

#  property :id, Serial
  property :name, String, :length => 20, :required => true
  property :en, Text
  property :ee, Text
end

