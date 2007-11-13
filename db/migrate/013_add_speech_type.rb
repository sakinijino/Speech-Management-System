class AddSpeechType < ActiveRecord::Migration
  def self.up
    add_column :speeches, :speech_type, :string
    Speech.update_all("speech_type = 'Work Report'")
  end

  def self.down
    remove_column :speeches, :speech_type
  end
end
