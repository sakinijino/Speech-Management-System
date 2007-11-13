class AddUserNameToSpeech < ActiveRecord::Migration
  def self.up
    add_column :speeches, :speaker_name, :string
  end

  def self.down
    remove_column :speeches, :speaker_name
  end
end
