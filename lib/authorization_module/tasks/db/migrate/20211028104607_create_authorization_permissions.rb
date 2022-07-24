class CreateAuthorizationPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_permissions, id: false do |t|
      t.string :id,          null: false, limit: 36, primary_key: true
      t.string  :owner_id,   null: false, limit: 36
      t.string  :policy_id,  null: false, limit: 36
      t.string  :owner_type, null: false
      t.json :conditions

      t.timestamps
    end

    add_index :authorization_permissions, %i[owner_id policy_id], unique: true, name: 'unique_permissions_owner_id_policy_id'
    add_foreign_key :authorization_permissions, :authorization_policies, column: :policy_id
  end
end
