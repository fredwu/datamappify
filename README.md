# Datamappify [![Gem Version](https://badge.fury.io/rb/datamappify.png)](http://badge.fury.io/rb/datamappify) [![Build Status](https://api.travis-ci.org/fredwu/datamappify.png?branch=master)](http://travis-ci.org/fredwu/datamappify) [![Coverage Status](https://coveralls.io/repos/fredwu/datamappify/badge.png)](https://coveralls.io/r/fredwu/datamappify) [![Code Climate](https://codeclimate.com/github/fredwu/datamappify.png)](https://codeclimate.com/github/fredwu/datamappify)

## Overview

Compose and manage domain logic and data persistence separately and intelligently, Datamappify is loosely based on the [Repository Pattern](http://martinfowler.com/eaaCatalog/repository.html) and [Entity Aggregation](http://msdn.microsoft.com/en-au/library/ff649505.aspx).

Datamappify is built using [Virtus](https://github.com/solnic/virtus) and existing ORMs (ActiveRecord and Sequel, etc). The design goal is to utilise the powerfulness of existing ORMs as well as to separate domain logic (model behaviour) from data persistence.

My motivation for creating Datamappify is to hide the complexity of dealing with data in different data sources including the ones from external web services. Features like lazy loading and dirty tracking are designed to enhance the usability of dealing with web services.

Datamappify consists of three components:

- __Entity__ contains models behaviour, think an ActiveRecord model with the persistence specifics removed.
- __Repository__ is responsible for data retrieval and persistence, e.g. `find`, `save` and `destroy`, etc.
- __Data__ as the name suggests, holds your model data. It contains ORM objects (ActiveRecord and Sequel, etc).

Below is a high level and somewhat simplified overview of Datamappify's architecture.

![](http://i.imgur.com/byt6P3f.png)

Note: Datamappify is NOT affiliated with the [Datamapper](https://github.com/datamapper/) project.

### Built-in ORMs for Persistence

You may implement your own [data provider and criterias](lib/datamappify/data), but Datamappify comes with build-in support for the following ORMS:

- ActiveRecord
- Sequel

## Installation

Add this line to your application's Gemfile:

    gem 'datamappify'

## Usage

### Entity

Entity uses [Virtus](https://github.com/solnic/virtus) DSL for defining attributes and [ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations.html) DSL for validations.

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

When an entity is lazy loaded, only attributes from the default source will be loaded. Other attributes will only be loaded once they are called. This is especially useful if some of your data sources are external services.

### Repository

Map entity attributes to DB columns - better yet, you can even map attributes to __different ORMs__!

```ruby
class UserRepository
  include Datamappify::Repository

  # specify the entity class
  for_entity User

  # specify the default data provider for unmapped attributes
  default_provider :ActiveRecord

  # specify any attributes that need to be mapped
  #
  # for example:
  #   - 'last_name' is mapped to the 'User' ActiveRecord class and its 'surname' attribute
  #   - 'driver_license' is mapped to the 'UserDriverLicense' ActiveRecord class and its 'number' attribute
  #   - 'passport' is mapped to the 'UserPassport' Sequel class and its 'number' attribute
  #   - attributes not specified here are mapped automatically to 'ActiveRecord::User'
  map_attribute :last_name,      'ActiveRecord::User#surname'
  map_attribute :driver_license, 'ActiveRecord::UserDriverLicense#number'
  map_attribute :passport,       'Sequel::UserPassport#number'
  map_attribute :health_care,    'Sequel::UserHealthCare#number'
end
```

Inheritance is supported for repositories when your data structure is based on STI ([Single Table Inheritance](http://en.wikipedia.org/wiki/Single_Table_Inheritance)), for example:

```ruby
class AdminUserRepository < UserRepository
  for_entity AdminUser
end

class GuestUserRepository < UserRepository
  for_entity GuestUser

  map_attribute :expiry, 'ActiveRecord::User#expiry_date'
end
```

In the above example, both repositories deal with the `User` data model.

### Repository APIs

_More repository APIs are being added, below is a list of the currently implemented APIs._

#### Retrieving an entity

Pass in an id.

```ruby
user = UserRepository.find(1)
```

#### Checking if an entity exists in the repository

Pass in an entity.

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

```ruby
users = UserRepository.find(:first_name => 'Fred', :driver_license => 'AABBCCDD')
```

_Note: it does not currently support searching attributes from different data providers._

#### Saving/updating entities

Pass in an entity.

There is also `save!` that raises `Datamappify::Data::EntityNotSaved`.

```ruby
UserRepository.save(user)
```

Datamappify supports attribute dirty tracking - only dirty attributes will be saved.

##### Mark attributes as dirty

Sometimes it's useful to manually mark the whole entity, or some attributes in the entity to be dirty - i.e. when you are submitting a form and only want to update the changed attributes. In this case, you could:

```ruby
UserRepository.states.mark_as_dirty(user)

UserRepository.states.find(user).changed?            #=> true
UserRepository.states.find(user).first_name_changed? #=> true
UserRepository.states.find(user).last_name_changed?  #=> true
UserRepository.states.find(user).age_changed?        #=> true
```

Or:

```ruby
UserRepository.states.mark_as_dirty(user, :first_name, :last_name)

UserRepository.states.find(user).changed?            #=> true
UserRepository.states.find(user).first_name_changed? #=> true
UserRepository.states.find(user).last_name_changed?  #=> true
UserRepository.states.find(user).age_changed?        #=> false
```

#### Destroying an entity

Pass in an entity.

There is also `destroy!` that raises `Datamappify::Data::EntityNotDestroyed`.

Note that due to the attributes mapping, any data found in mapped ActiveRecord objects are not touched.

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

Callbacks are defined in repositories, and they have access to the entity. Example:

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

Note: Returning either `nil` or `false` from the callback will cancel all subsequent callbacks (and the action itself, it it's a `before_` callback).

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
- [Locomote](http://www.locomote.com.au/) - where Datamappify is built and being tested in product development.

## License

Licensed under [MIT](http://fredwu.mit-license.org/)
