class ForumPost < ActiveRecord::Base
  
  belongs_to :speech
  belongs_to :user
  
  acts_as_threaded
  validates_length_of :subject, :within => 1..255
  
end
