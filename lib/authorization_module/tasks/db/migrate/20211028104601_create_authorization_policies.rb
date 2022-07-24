class CreateAuthorizationPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_policies, id: false do |t|
      t.string  :id,            null: false, limit: 36, primary_key: true
      t.string  :name,          null: false
      t.string  :description
      t.string  :resource_type, null: false
      t.string  :action,        null: false
      t.integer :effect,        null: false, limit: 1

      t.timestamps
    end

    add_index :authorization_policies, %i[name], unique: true, name: 'unique_policies_name'
    add_index :authorization_policies, %i[resource_type action effect], unique: true, name: 'unique_resource_type_action_effect'
  end
end
