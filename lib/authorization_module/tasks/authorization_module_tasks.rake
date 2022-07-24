namespace 'authorization_module' do
  desc 'Copy Migration files'
  task :copy_migration_files do
    migration_folder = "#{ Dir.pwd }/db/migrate"
    timestap = DateTime.now.to_i
    migration_files = [
        {
            file_name: "##{timestap}_create_authorization_identities.rb",
            content: "
              class CreateAuthorizationIdentities < ActiveRecord::Migration[6.0]
                def change
                  create_table :authorization_identities, id: false do |t|
                    t.string :id,       null: false, limit: 36, primary_key: true
                    t.string :group_id, null: false, limit: 36
                  end
                end
              end
            "
        },
        {
            file_name: "##{timestap + 1}_create_authorization_policies.rb",
            content: "
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
            "
        },
        {
            file_name: "##{timestap + 2}_create_authorization_permissions.rb",
            content: "
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
            "
        },
        {
            file_name: "##{timestap + 3}_create_authorization_roles.rb",
            content: "
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
            "
        },
        {
            file_name: "##{timestap + 4}_create_authorization_user_groups.rb",
            content: "
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
            "
        },
        {
            file_name: "##{timestap + 5}_create_authorization_role_grants.rb",
            content: "
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
            "
        }
    ]
    FileUtils.mkdir_p migration_folder
    puts "Created #{ migration_folder }"
    migration_files.each do |file_info|
      puts "Creating file #{migration_folder}/#{file_info[:file_name]} with content:"
      puts "#{file_info[:content]}"
      File.open("#{migration_folder}/#{file_info[:file_name]}", "w") { |file|
        file.puts "#{file_info[:content]}"
      }
      puts "Creation of file #{migration_folder}/#{file_info[:file_name]} done."
    end
  end

  desc 'Creates configuration files'
  task :install do
    Rake::Task['authorization_gem:copy_migration_files'].execute
  end
end