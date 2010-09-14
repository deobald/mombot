
class Image < ActiveRecord::Base
  belongs_to :pez
  has_attachment :content_type => :image, :storage => :file_system, 
                 :path_prefix => 'public/attachments', :max_size => 1.megabyte
                 
  validates_as_attachment  
end
