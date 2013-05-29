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

Returns an array of user entities.

```ruby
users = UserRepository.all
```

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

- Entity composition, so you could use Datamappify for forms data (similar to [Reform](https://github.com/apotonick/reform))
- [Authoritative source](http://msdn.microsoft.com/en-au/library/ff649505.aspx).
- Enforce attribute type casting.
- Support for configurable primary keys and foreign keys.

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
