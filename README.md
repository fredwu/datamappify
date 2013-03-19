# Datamappify [![Gem Version](https://badge.fury.io/rb/datamappify.png)](http://badge.fury.io/rb/datamappify) [![Build Status](https://api.travis-ci.org/fredwu/datamappify.png)](http://travis-ci.org/fredwu/datamappify) [![Coverage Status](https://coveralls.io/repos/fredwu/datamappify/badge.png)](https://coveralls.io/r/fredwu/datamappify) [![Code Climate](https://codeclimate.com/github/fredwu/datamappify.png)](https://codeclimate.com/github/fredwu/datamappify)

Separate domain logic from data persistence, based on the [Repository Pattern](http://martinfowler.com/eaaCatalog/repository.html).

Datamappify is NOT associated with the [Datamapper](https://github.com/datamapper/) project.

__Datamappify is current in Proof-of-Concept stage, do NOT use it for anything other than experimentation.__

## Overview

Datamappify is a thin layer on top of [Virtus](https://github.com/solnic/virtus) and existing ORMs (ActiveRecord, etc). The design goal is to utilise the powerfulness of existing ORMs but separate domain logic (behaviour) from data persistence.

Datamappify consists of three components:

- __Entity__ is your model, it is responsible for mainly storing behaviour.
- __Data__ as the name suggests, holds your model data. It is an ActiveRecord object.
- __Repository__ is responsible for data retrieval and persistence, e.g. `find`, `save` and `destroy`, etc.

## Installation

Add this line to your application's Gemfile:

    gem 'datamappify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install datamappify

## Usage

### Entity

```ruby
class User
  include Datamappify::Entity

  attribute :first_name,     String
  attribute :last_name,      String
  attribute :age,            Integer
  attribute :passport,       String
  attribute :driver_license, String
  attribute :health_care,    String

  validates :first_name, :presence => true,
                         :length   => { :minimum => 2 }
  validates :passport,   :presence => true,
                         :length   => { :minimum => 8 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

### Repository

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
  #   - 'passport' is mapped to the 'UserPassport' ActiveRecord class and its 'number' attribute
  #   - attributes not specified here are mapped automatically to 'ActiveRecord::User'
  map_attribute :last_name,      'ActiveRecord::User#surname'
  map_attribute :driver_license, 'ActiveRecord::UserDriverLicense#number'
  map_attribute :passport,       'ActiveRecord::UserPassport#number'
  map_attribute :health_care,    'ActiveRecord::UserHealthCare#number'
end
```

#### Retrieving entities

Pass in an id or an array of ids.

```ruby
user  = UserRepository.instance.find(1)
users = UserRepository.instance.find([1, 2, 3])
```

#### Saving/updating entities

Pass in an entity or an array of entities.

There is also `save!` that raises `Datamappify::Data::EntityNotSaved`.

```ruby
UserRepository.instance.save(user)
UserRepository.instance.save([user, user2, user3])
```

#### Destroying an entity

Pass in an entity, an id, an array of entities or an array of ids.

There is also `destroy!` that raises `Datamappify::Data::EntityNotDestroyed`.

Note that due to the attributes mapping, any data found in mapped ActiveRecord objects are not touched.

```ruby
UserRepository.instance.destroy(1)
UserRepository.instance.destroy([1, 2, 3])
UserRepository.instance.destroy(user)
UserRepository.instance.destroy([user, user2, user3])
```

## Supported ORMs

- ActiveRecord

## Changelog

Refer to [CHANGELOG](CHANGELOG.md).

## Todo

- Enforce attribute type casting.
- Hooks for persistence (`before_save` and `after_save`, etc).
- Track dirty entity attributes to avoid unnecessary DB queries.
- Support for configurable primary keys and foreign keys.
- Entity should dictate Data, so schema and migrations should be automatically generated.
- Support for multiple ORMs on attribute level.

## Similar Projects

- [Curator](https://github.com/braintree/curator)
- [Edr](https://github.com/nulogy/edr)
- [Minimapper](https://github.com/joakimk/minimapper)

## Author

[Fred Wu](http://fredwu.me/)

## License

Licensed under [MIT](http://fredwu.mit-license.org/)
