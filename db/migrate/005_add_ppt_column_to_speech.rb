class AddPptColumnToSpeech < ActiveRecord::Migration
  def self.up
    add_column :speeches, :ppt, :string
  end

  def self.down
    remove_column :speeches, :ppt   
  end
end
