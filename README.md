# Datamappify [![Gem Version](https://badge.fury.io/rb/datamappify.png)](http://badge.fury.io/rb/datamappify) [![Build Status](https://api.travis-ci.org/fredwu/datamappify.png?branch=master)](http://travis-ci.org/fredwu/datamappify) [![Coverage Status](https://coveralls.io/repos/fredwu/datamappify/badge.png)](https://coveralls.io/r/fredwu/datamappify) [![Code Climate](https://codeclimate.com/github/fredwu/datamappify.png)](https://codeclimate.com/github/fredwu/datamappify)

#### Compose, decouple and manage domain logic and data persistence separately. Works particularly great for composing form objects!

## Overview

The typical Rails (and ActiveRecord) way of building applications is great for small to medium sized projects, but when projects grow larger and more complex, your models too become larger and more complex - it is not uncommon to have god classes such as a User model.

Datamappify tries to solve two common problems in web applications:

1. The coupling between domain logic and data persistence.
2. The coupling between forms and models.

Datamappify is loosely based on the [Repository Pattern](http://martinfowler.com/eaaCatalog/repository.html) and [Entity Aggregation](http://msdn.microsoft.com/en-au/library/ff649505.aspx), and is built on top of [Virtus](https://github.com/solnic/virtus) and existing ORMs (ActiveRecord and Sequel, etc).

There are three main design goals:

1. To utilise the powerfulness of existing ORMs so that using Datamappify doesn't interrupt too much of your current workflow. For example, [Devise](https://github.com/plataformatec/devise) would still work if you use it with a `UserAccount` ActiveRecord model that is attached to a `User` entity managed by Datamappify.
2. To have a flexible entity model that works great with dealing with form data. For example, [SimpleForm](https://github.com/plataformatec/simple_form) would still work with nested attributes from different ORM models if you map entity attributes smartly in your repositories managed by Datamappify.
3. To have a set of data providers to encapsulate the handling of how the data is persisted. This is especially useful for dealing with external data sources such as a web service. For example, by calling `UserRepository.save(user)`, certain attributes of the user entity are now persisted on a remote web service. Better yet, dirty tracking and lazy loading are supported out of the box!

Datamappify consists of three components:

- __Entity__ contains models behaviour, think an ActiveRecord model with the persistence specifics removed.
- __Repository__ is responsible for data retrieval and persistence, e.g. `find`, `save` and `destroy`, etc.
- __Data__ as the name suggests, holds your model data. It contains ORM objects (e.g. ActiveRecord models).

Below is a high level and somewhat simplified overview of Datamappify's architecture.

![](http://i.imgur.com/I9GpLds.png)

Note: Datamappify is NOT affiliated with the [Datamapper](https://github.com/datamapper/) project.

### Built-in ORMs for Persistence

You may implement your own [data provider and criteria](lib/datamappify/data), but Datamappify comes with build-in support for the following ORMS:

- ActiveRecord
- Sequel

## Installation

Add this line to your application's Gemfile:

    gem 'datamappify'

## Usage

### Entity

Entity uses [Virtus](https://github.com/solnic/virtus) DSL for defining attributes and [ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations.html) DSL for validations.

The cool thing about Virtus is that all your attributes get [coercion](https://github.com/solnic/virtus#collection-member-coercions) for free!

Below is an example of a User entity, with inline comments on how some of the DSLs work.

```ruby
class User
  include Datamappify::Entity

  attribute :first_name,     String
  attribute :last_name,      String
  attribute :age,            Integer
  attribute :passport,       String
  attribute :driver_license, String
  attribute :health_care,    String

  # Nested entity composition - composing the entity with attributes and validations from other entities
  #
  #   class Job
  #     include Datamappify::Entity
  #
  #     attributes :title, String
  #     validates  :title, :presence => true
  #   end
  #
  #   class User
  #     # ...
  #     attributes_from Job
  #   end
  #
  # essentially equals:
  #
  #   class User
  #     # ...
  #     attributes :title, String
  #     validates  :title, :presence => true
  #   end
  attributes_from Job

  # optionally you may prefix the attributes, so that:
  #
  #   class Hobby
  #     include Datamappify::Entity
  #
  #     attributes :name, String
  #     validates  :name, :presence => true
  #   end
  #
  #   class User
  #     # ...
  #     attributes_from Hobby, :prefix_with => :hobby
  #   end
  #
  # becomes:
  #
  #   class User
  #     # ...
  #     attributes :hobby_name, String
  #     validates  :hobby_name, :presence => true
  #   end
  attributes_from Hobby, :prefix_with => :hobby

  # Entity reference
  #
  # `references` is a convenient method for:
  #
  #   attribute :account_id, Integer
  #   attr_accessor :account
  #
  # and it assigns `account_id` the correct value:
  #
  #   user.account = account #=> user.account_id = account.id
  references :account

  validates :first_name, :presence => true,
                         :length   => { :minimum => 2 }
  validates :passport,   :presence => true,
                         :length   => { :minimum => 8 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

#### Entity inheritance

Inheritance is supported for entities, for example:

```ruby
class AdminUser < User
  attribute :level, Integer
end

class GuestUser < User
  attribute :expiry, DateTime
end
```

#### Lazy loading

Datamappify supports attribute lazy loading via the `Lazy` module.

```ruby
class User
  include Datamappify::Entity
  include Datamappify::Lazy
end
```

When an entity is lazy loaded, only attributes from the primary source (e.g. `User` entity's primary source would be `ActiveRecord::User` as specified in the corresponding repository) will be loaded. Other attributes will only be loaded once they are called. This is especially useful if some of your data sources are external web services.

### Repository

Repository maps entity attributes to DB columns - better yet, you can even map attributes to __different ORMs__!

Below is an example of a repository for the User entity, you can have more than one repositories for the same entity.

```ruby
class UserRepository
  include Datamappify::Repository

  # specify the entity class
  for_entity User

  # specify the default data provider for unmapped attributes
  # optionally you may use `Datamappify.config` to config this globally
  default_provider :ActiveRecord

  # specify any attributes that need to be mapped
  #
  # for attributes mapped from a different source class, a foreign key on the source class is required
  #
  # for example:
  #   - 'last_name' is mapped to the 'User' ActiveRecord class and its 'surname' attribute
  #   - 'driver_license' is mapped to the 'UserDriverLicense' ActiveRecord class and its 'number' attribute
  #   - 'passport' is mapped to the 'UserPassport' Sequel class and its 'number' attribute
  #   - attributes not specified here are mapped automatically to 'User' with provider 'ActiveRecord'
  map_attribute :last_name,      :to => 'User#surname'
  map_attribute :driver_license, :to => 'UserDriverLicense#number'
  map_attribute :passport,       :to => 'UserPassport#number',   :provider => :Sequel
  map_attribute :health_care,    :to => 'UserHealthCare#number', :provider => :Sequel

  # alternatively, you may group attribute mappings if they share certain options:
  group :provider => :Sequel do
    map_attribute :passport,    :to => 'UserPassport#number'
    map_attribute :health_care, :to => 'UserHealthCare#number'
  end

  # attributes can also be reverse mapped by specifying the `via` option
  #
  # for example, the below attribute will look for `hobby_id` on the user object,
  # and map `hobby_name` from the `name` attribute of `ActiveRecord::Hobby`
  #
  # this is useful for mapping form fields (similar to ActiveRecord's nested attributes)
  map_attribute :hobby_name, :to => 'Hobby#name', :via => :hobby_id
end
```

#### Repository inheritance

Inheritance is supported for repositories when your data structure is based on STI ([Single Table Inheritance](http://en.wikipedia.org/wiki/Single_Table_Inheritance)), for example:

```ruby
class AdminUserRepository < UserRepository
  for_entity AdminUser
end

class GuestUserRepository < UserRepository
  for_entity GuestUser

  map_attribute :expiry, :to => 'User#expiry_date'
end
```

In the above example, both repositories deal with the `ActiveRecord::User` data model.

#### Override mapped data models

Datamappify repository by default creates the underlying data model classes for you. For example:

```ruby
map_attribute :driver_license, :to => 'UserData::DriverLicense#number'
```

In the above example, a `Datamppify::Data::Record::ActiveRecord::UserDriverLicense` ActiveRecord model will be created. If you would like to customise the data model class, you may do so by creating one either under the default namespace or under the `Datamappify::Data::Record::NameOfDataProvider` namespace:

```ruby
module UserData
  class DriverLicense < ActiveRecord::Base
    # your customisation...
  end
end
```

```ruby
module Datamappify::Data::Record::ActiveRecord::UserData
  class DriverLicense < ::ActiveRecord::Base
    # your customisation...
  end
end
```

### Repository APIs

_More repository APIs are being added, below is a list of the currently implemented APIs._

#### Retrieving an entity

Accepts an id.

```ruby
user = UserRepository.find(1)
```

#### Checking if an entity exists in the repository

Accepts an entity.

```ruby
UserRepository.exists?(user)
```

#### Retrieving all entities

Returns an array of entities.

```ruby
users = UserRepository.all
```

#### Searching entities

Returns an array of entities.

##### Simple

```ruby
users = UserRepository.where(:first_name => 'Fred', :driver_license => 'AABBCCDD')
```

##### Match

```ruby
users = UserRepository.match(:first_name => 'Fre%', :driver_license => '%bbcc%')
```

##### Advanced

You may compose search criteria via the `criteria` method.

```ruby
users = UserRepository.criteria(
  :where => {
    :first_name => 'Fred'
  },
  :order => {
    :last_name => :asc
  },
  :limit => 10
)
```

Currently implemented criteria options:

- where(Hash)
- match(Hash)
- order(Hash)
- limit(Integer)

_Note: it does not currently support searching attributes from different data providers._

#### Saving/updating entities

Accepts an entity.

There is also `save!` that raises `Datamappify::Data::EntityNotSaved`.

```ruby
UserRepository.save(user)
```

Datamappify supports attribute dirty tracking - only dirty attributes will be saved.

##### Mark attributes as dirty

Sometimes it's useful to manually mark the whole entity, or some attributes in the entity to be dirty. In this case, you could:

```ruby
UserRepository.states.mark_as_dirty(user) # marks the whole entity as dirty

UserRepository.states.find(user).changed?            #=> true
UserRepository.states.find(user).first_name_changed? #=> true
UserRepository.states.find(user).last_name_changed?  #=> true
UserRepository.states.find(user).age_changed?        #=> true
```

Or:

```ruby
UserRepository.states.mark_as_dirty(user, :first_name, :last_name) # marks only first_name and last_name as dirty

UserRepository.states.find(user).changed?            #=> true
UserRepository.states.find(user).first_name_changed? #=> true
UserRepository.states.find(user).last_name_changed?  #=> true
UserRepository.states.find(user).age_changed?        #=> false
```

#### Destroying an entity

Accepts an entity.

There is also `destroy!` that raises `Datamappify::Data::EntityNotDestroyed`.

Note that due to the attributes mapping, any data found in mapped records are not touched. For example the corresponding `ActiveRecord::User` record will be destroyed, but `ActiveRecord::Hobby` that is associated will not.

```ruby
UserRepository.destroy(user)
```

#### Callbacks

Datamappify supports the following callbacks via [Hooks](https://github.com/apotonick/hooks):

- before_create
- before_update
- before_save
- before_destroy
- after_create
- after_update
- after_save
- after_destroy

Callbacks are defined in repositories, and they have access to the entity. For example:

```ruby
class UserRepository
  include Datamappify::Repository

  before_create :make_me_admin
  before_create :make_me_awesome
  after_save    :make_me_smile

  private

  def make_me_admin(entity)
    # ...
  end

  def make_me_awesome(entity)
    # ...
  end

  def make_me_smile(entity)
    # ...
  end

  # ...
end
```

Note: Returning either `nil` or `false` from the callback will cancel all subsequent callbacks (and the action itself, if it's a `before_` callback).

### Association

Datamappify also supports entity association. It is experimental and it currently supports the following association types:

- belongs_to
- has_many

Set up your entities and repositories:

```ruby
# entities

class User
  include Datamappify::Entity

  has_many :posts, :via => Post
end

class Post
  include Datamappify::Entity

  belongs_to :user
end

# repositories

class UserRepository
  include Datamappify::Repository

  for_entity User

  references :posts, :via => PostRepository
end

class PostRepository
  include Datamappify::Repository

  for_entity Post
end
```

Usage examples:

```ruby
new_post         = Post.new(post_attributes)
another_new_post = Post.new(post_attributes)
user             = UserRepository.find(1)
user.posts       = [new_post, another_new_post]

persisted_user   = UserRepository.save!(user)

persisted_user.posts #=> an array of associated posts
```

### Default configuration

You may configure Datamappify's default behaviour. In Rails you would put it in an initializer file.

```ruby
Datamappify.config do |c|
  c.default_provider = :ActiveRecord
end
```

## More Reading

You may check out this [article](http://fredwu.me/post/54009567748/) for more examples.

## Changelog

Refer to [CHANGELOG](CHANGELOG.md).

## Todo

- [Authoritative source](http://msdn.microsoft.com/en-au/library/ff649505.aspx).
- Support for configurable primary keys and reference (foreign) keys.

## Similar Projects

- [Curator](https://github.com/braintree/curator)
- [Edr](https://github.com/nulogy/edr)
- [Minimapper](https://github.com/joakimk/minimapper)
- [Reform](https://github.com/apotonick/reform)

## Credits

- [Fred Wu](http://fredwu.me/) - author.
- [James Ladd](http://jamesladdcode.com/) for reviewing the code and giving advice on architectural decisions.
- [Locomote](http://www.locomote.com.au/) - where Datamappify is built and used in our products.
- And with these [awesome contributors](https://github.com/fredwu/datamappify/contributors)!

## License

Licensed under [MIT](http://fredwu.mit-license.org/)
