class CreateAuthorizationUserGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_user_groups, id: false do |t|
      t.string :id,          null: false, limit: 36, primary_key: true
      t.string :name,        null: false
      t.string :description

      t.timestamps
    end

    add_index :authorization_user_groups, %i[name], unique: true, name: 'unique_user_groups_name'
    add_foreign_key :authorization_identities, :authorization_user_groups, column: :group_id
  end
end
