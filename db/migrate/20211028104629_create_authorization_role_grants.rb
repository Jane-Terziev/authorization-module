class CreateAuthorizationRoleGrants < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_role_grants, id: false do |t|
      t.string :id, null: false, limit: 36
      t.string :identity_id, null: false, limit: 36
      t.string :role_id,     null: false, limit: 36

      t.timestamps
    end

    add_index :authorization_role_grants, %i[identity_id], unique: true, name: 'unique_role_grants_identity_id'
    add_foreign_key :authorization_role_grants, :authorization_identities, column: :identity_id,
                    on_delete: :cascade, on_update: :cascade
    add_foreign_key :authorization_role_grants, :authorization_roles, column: :role_id,
                    on_delete: :cascade, on_update: :cascade
  end
end
