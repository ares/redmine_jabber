class AddJidTokenAndJidAuthenticatedFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :jid_token, :string, :null => true
    add_column :users, :jid_authenticated, :boolean, :null => false, :default => false
    User.all(:conditions => 'jid IS NOT NULL').each do |user|
      user.update_attribute :jid_authenticated , true
    end
  end

  def self.down
    remove_column :users, :jid_token
    remove_column :users, :jid_authenticated
  end
end
