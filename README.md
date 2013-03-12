### [![](http://stillmaintained.com/fredwu/datamappify.png)](http://stillmaintained.com/fredwu/datamappify) Datamappify has long been abandoned. Please see [MiniRecord](https://github.com/DAddYE/mini_record) instead. :)

# Datamappify

## Introduction

ActiveRecord is without doubt the *de facto* ORM library for Rails and many Ruby web frameworks. Many developers however, do not like database migrations and prefer to use DSL for data mapping. Datamappify is created with the sole purpose of getting rid of the DB migration headaches.

Brought to you by [Envato](http://envato.com) and [Wuit](http://wuit.com).

## Disclaimer

**This plugin is NOT production-ready yet!** Use with caution.

### Todo

* Add tests
* Possibly refactor `add_index` to be part of the `property` definition (as seen in the [DataMapper](http://datamapper.org/) library)

## Why?

### Why Not DB Migrations?

Well, depending on your specific project, DB migrations might create more trouble than it's worth. Besides, your code is already version controlled, so why create a separate version control for your DB schema?

### Why Not Use DataMapper, Sequel, etc?

As stated in the introduction, ActiveRecord is the most popular ORM in the rails community, it is actively developed and battle-tested. If your only grief with ActiveRecord is the DB migrations, why not just eliminate it be happy? ;)

## How?

How does this plugin work?

Basically, it -

1. Uses a DSL similar to DataMapper's for defining model properties (DB mapping).
2. `schema.rb` is automatically updated according to the model properties.
3. Automatically 'migrates' the database according to the updated schema file.

## Installation

    gem install datamappify

Don't forget to include the library in your `Gemfile`:

    gem 'datamappify'

## Usage

Here's an example to get you started:

  	class User < ActiveRecord::Base
  	  include Datamappify::Resource
      
  	  property  :email, :string
  	  property  :password, :string, :limit => 40
  	  property  :first_name, :string, :limit => 50
  	  property  :last_name, :string, :limit => 50
  	  property  :payment_email, :string
  	  property  :timestamps
  	  add_index :email
  	  add_index :payment_email
  	  add_index :role_id
      
  	  belongs_to :role
  	end

It will create the following schema:

  	create_table "users", :force => true do |t|
  	  t.string   :email,               :limit => nil
  	  t.string   :password,            :limit => nil
  	  t.string   :first_name,          :limit => nil
  	  t.string   :last_name,           :limit => nil
  	  t.string   :payment_email,       :limit => nil
  	  t.integer  :role_id,             :limit => nil
  	  t.datetime :created_at
  	  t.datetime :updated_at
  	end

  	add_index "users", :email
  	add_index "users", :payment_email
  	add_index "users", :role_id

#### property()

Use `property` to define and map DB columns. It accepts a number of arguments:

1. Name of the column.
2. SQL type of the column, same as the ones provided by ActiveRecord migrations.
3. Column options, same as the ones provided by ActiveRecord migrations.

#### add_index()

Use `add_index` to add DB indexes. It accepts a number of arguments:

1. The column(s) to index on, can be just one column or a number of columns in an array.
3. Index options such as `name`, `unique` and `length`.

### Rake Tasks

To set up your database for the first time, please run:

    rake db:schema:update
    rake db:setup

Later on, to only update the `schema.rb` file, run:

    rake db:schema:update

To update `schema.rb` and to 'migrate' the updated database structure, run:

    rake db:schema:auto_migrate

## Author

Copyright (c) 2010 Fred Wu (<http://fredwu.me>), released under the MIT license

* Envato - <http://envato.com>
* Wuit - <http://wuit.com>
