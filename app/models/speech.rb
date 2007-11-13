class Speech < ActiveRecord::Base
  belongs_to :speaker,
                  :class_name=>'User',
                  :foreign_key=>'speaker_id'
  has_many :forum_posts,
                :dependent => :destroy
  file_column :attachment

  validates_file_format_of :attachment, :in => ["ppt", "pdf", "doc", "rar", "zip", "xls"]

  def date
    read_attribute("date" ).to_date if(read_attribute("date" ) != nil)
  end
end
