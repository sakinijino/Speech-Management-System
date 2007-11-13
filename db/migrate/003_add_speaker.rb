class AddSpeaker < ActiveRecord::Migration
  def self.up
    add_column :speeches, :speaker_id, :integer
  end

  def self.down
    remove_column :speeches, :speaker_id
  end
end
