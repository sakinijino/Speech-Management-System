class CreateSpeeches < ActiveRecord::Migration
  def self.up
    create_table :speeches do |t|
      t.column :date, :datetime
      t.column :topic, :string
      t.column :abstract, :text
    end
  end

  def self.down
    drop_table :speeches
  end
end
