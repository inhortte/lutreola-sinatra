require 'dm-core'
require 'dm-migrations'

include DataMapper::Resource

pages = %w(news fl mission contact who obj act part cb eep study husb eepfac memb species links)

pages.each do |page|
  puts "creating #{page}"
  klass = Class.new do
    property :id, Serial
    property :name, String, :length => 20, :required => true
    property :order, Integer
    property :en, Text
    property :ee, Text
  end
  Object.const_set page.capitalize, klass
end
exit

class Photo
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 20, :required => true
  property :order, Integer
  property :show, Boolean, :default => true, :required => true
  property :thumb, String, :length => 255, :required => true
  property :photo, String, :length => 255, :required => true
  property :en, Text
  property :ee, Text
end

class Sidebar
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 20, :required => true
  property :en, Text
  property :ee, Text
end

class Menu
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 20, :required => true
  property :en, Text
  property :ee, Text
end

