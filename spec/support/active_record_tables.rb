ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => ':memory:'
  )

  ActiveRecord::Schema.define(:version => 0) do
    begin
      drop_table :users
      drop_table :comments
      drop_table :roles
    rescue
    end

    create_table :users do |t|
      t.string :first_name, :null => false
      t.string :last_name
      t.string :sex,        :null => false
      t.integer :age
      t.references :role
      t.timestamps
    end

    create_table :comments do |t|
      t.string :content
      t.belongs_to :user
      t.timestamps
    end

    create_table :roles do |t|
      t.string :name
      t.timestamps
    end

    create_table :groups do |t|
      t.string :name
      t.timestamps
    end

    create_table :groups_users do |t|
      t.belongs_to :user
      t.belongs_to :group
    end

    create_table :user_passports do |t|
      t.string :number
      t.belongs_to :user
      t.timestamps
    end

    create_table :user_driver_licenses do |t|
      t.string :number
      t.string :expiry, :null => false
      t.belongs_to :user
      t.timestamps
    end
  end
end
