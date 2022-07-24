namespace 'authorization_module' do
  desc 'Copy Migration files'
  task :copy_migration_files do
    migration_destination_folder = "#{ Dir.pwd }/db/migrate"
    migration_source_folder = File.expand_path('../db/migrate', __FILE__)
    migration_files = [
        {
            file_name: "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authorization_identities.rb",
            content: File.open("#{migration_source_folder}/20211028103954_create_authorization_identities.rb").read
        },
        {
            file_name: "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authorization_policies.rb",
            content: File.open("#{migration_source_folder}/20211028104601_create_authorization_policies.rb").read
        },
        {
            file_name: "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authorization_permissions.rb",
            content: File.open("#{migration_source_folder}/20211028104607_create_authorization_permissions.rb").read
        },
        {
            file_name: "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authorization_roles.rb",
            content: File.open("#{migration_source_folder}/20211028104614_create_authorization_roles.rb").read
        },
        {
            file_name: "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authorization_user_groups.rb",
            content: File.open("#{migration_source_folder}/20211028104622_create_authorization_user_groups.rb").read
        },
        {
            file_name: "#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authorization_role_grants.rb",
            content: File.open("#{migration_source_folder}/20211028104629_create_authorization_role_grants.rb").read
        }
    ]
    FileUtils.mkdir_p migration_destination_folder
    puts "Created #{ migration_destination_folder }"
    migration_files.each do |file_info|
      puts "Creating file #{migration_destination_folder}/#{file_info[:file_name]} with content:"
      puts "#{file_info[:content]}"
      File.open("#{migration_destination_folder}/#{file_info[:file_name]}", "w") { |file|
        file.puts "#{file_info[:content]}"
      }
      puts "Creation of file #{migration_destination_folder}/#{file_info[:file_name]} done."
    end
  end

  desc 'Create a configuration file'
  task :create_configuration_file do
    destination_folder = "#{ Dir.pwd }/config/initializers"
    source_folder = File.expand_path('../config', __FILE__)
    file_name = "authorization_module.rb"
    FileUtils.mkdir_p destination_folder
    puts "Created #{ destination_folder }/#{file_name}"
    File.open("#{ destination_folder }/#{file_name}", "w") { |file|
      file.puts File.open("#{source_folder}/#{file_name}").read
    }
  end

  task :install do
    Rake::Task['authorization_gem:copy_migration_files'].execute
    Rake::Task['authorization_gem:create_configuration_file'].execute
  end
end