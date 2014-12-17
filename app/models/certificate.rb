require 'paperclip_montage' # @FIXME: hacky

class Certificate < ActiveRecord::Base
  attr_accessible :name, :montage_file_name, :montage
  has_and_belongs_to_many :courses
  belongs_to :teacher

  has_attached_file :montage,
    processors: [:montage],
    :default_url => "/assets/:style/missing.png",
    :path => "certificates/:attachment/:id_partition/:style/:filename",
    :url => "/dynamic/certificates/montages/:id_partition/:style/:basename.:extension",
    :styles => {
      medium: { geometry: "300x300>", source: :courses},
      thumb: { geometry: "100x100>", source: :courses }
    }, :storage => :redis

    validates_attachment :montage, attachment_presence: true,
      content_type: { :content_type => /\Aimage\/.*\Z/ }

    paginates_per 24

    validates_presence_of :name

    def reprocess_montage
      montage.reprocess!
      montage.flush_writes
    end
end
