class RenamePptToAttachment < ActiveRecord::Migration
  def self.up
    rename_column :speeches, :ppt, :attachment
  end

  def self.down
    rename_column :speeches, :attachment, :ppt
  end
end
