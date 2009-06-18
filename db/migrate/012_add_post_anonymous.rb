class AddPostAnonymous < ActiveRecord::Migration
  def self.up
    add_column :forum_posts, :is_anonymous, :boolean
  end

  def self.down
    remove_column :forum_posts, :is_anonymous
  end
end
