class AddJidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :jid, :string, :null => true
  end

  def self.down
    remove_column :users, :jid
  end
end
