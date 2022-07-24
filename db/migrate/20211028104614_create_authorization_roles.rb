class CreateAuthorizationRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_roles, id: false do |t|
      t.string :id,          null: false, limit: 36, primary_key: true
      t.string :name,        null: false, limit: 255
      t.string :description

      t.timestamps
    end

    add_index :authorization_roles, %i[name], unique: true, name: 'unique_roles_name'
  end
end
