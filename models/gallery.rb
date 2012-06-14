require 'carrierwave'
require 'dm-core'
require 'dm-migrations'

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  version :thumb do
    process :resize_to_fill => [100,100]
  end

  storage :file
end

class Photo
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :ee, Text
  property :en, Text
  property :taken, DateTime
  property :image, String, :auto_validation => false
  mount_uploader :image, PhotoUploader

  belongs_to :photographer
  has n, :collection_photos
  has n, :collections, :through => :collection_photo
end

class Collection
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :en, Text
  property :ee, Text

  has n, :collection_photos
  has n, :photos, :through => :collection_photo
end

class CollectionPhoto
  include DataMapper::Resource

  property :ordr, Integer, :default => 1
  belongs_to :photo, :key => true
  belongs_to :collection, :key => true
end

class Photographer
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :en, Text
  property :ee, Text

  belongs_to :member, :required => false
  has n, :photos
  before :save, :check_for_member

  private
  def check_for_member
    if self.member && self.member.member_info
      self.name = "#{self.member.member_info.first_name} #{self.member.member_info.last_name}" if !self.name
    end
  end
end
