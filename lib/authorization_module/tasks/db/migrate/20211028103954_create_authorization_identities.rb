class CreateAuthorizationIdentities < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_identities, id: false do |t|
      t.string :id,       null: false, limit: 36, primary_key: true
      t.string :group_id, null: false, limit: 36
    end
  end
end
