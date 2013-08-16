require 'sequel'

DB = Sequel.sqlite

DB.create_table :hero_user_last_names do
  primary_key :id
  String :last_name, :null => false
  String :gender
  Integer :hero_user_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :super_users do
  primary_key :id
  foreign_key :base_user_id
  foreign_key :group_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :users do
  primary_key :id
  String :first_name, :null => false
  String :surname
  Integer :age
  Integer :level
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :comments do
  primary_key :id
  String :content
  foreign_key :user_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :roles do
  primary_key :id
  String :name
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :groups do
  primary_key :id
  String :name
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :user_driver_licenses do
  primary_key :id
  String :number
  String :expiry
  foreign_key :user_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :user_passports do
  primary_key :id
  String :number
  String :expiry, :null => false
  foreign_key :user_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :user_health_cares do
  primary_key :id
  String :number
  String :expiry
  foreign_key :user_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :reversed_posts do |t|
  primary_key :id
  String :title
  foreign_key :author_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :reversed_authors do |t|
  primary_key :id
  String :name
  String :bio
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :computers do |t|
  primary_key :id
  String :brand
  foreign_key :game_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :computer_component_hardwares do |t|
  primary_key :id
  String :brand
  String :cpu
  Integer :ram
  Integer :hdd
  String :gfx
  String :vendor
  foreign_key :computer_id
  DateTime :created_at
  DateTime :updated_at
end

DB.create_table :computer_component_softwares do |t|
  primary_key :id
  String :os
  String :vendor
  foreign_key :computer_id
  foreign_key :osx_id
  foreign_key :windows_id
  foreign_key :linux_id
  DateTime :created_at
  DateTime :updated_at
end
