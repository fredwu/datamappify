# Datamappify [![Gem Version](https://badge.fury.io/rb/datamappify.png)](http://badge.fury.io/rb/datamappify) [![Build Status](https://api.travis-ci.org/fredwu/datamappify.png)](http://travis-ci.org/fredwu/datamappify) [![Coverage Status](https://coveralls.io/repos/fredwu/datamappify/badge.png)](https://coveralls.io/r/fredwu/datamappify) [![Code Climate](https://codeclimate.com/github/fredwu/datamappify.png)](https://codeclimate.com/github/fredwu/datamappify)

__Datamappify is current in Proof-of-Concept stage, do NOT use it for anything other than experimentation.__

## Overview

Compose and manage domain logic and data persistence separately and intelligently, Datamappify is loosely based on the [Repository Pattern](http://martinfowler.com/eaaCatalog/repository.html) and [Entity Aggregation](http://msdn.microsoft.com/en-au/library/ff649505.aspx).

Datamappify is built using [Virtus](https://github.com/solnic/virtus) and existing ORMs (ActiveRecord and Sequel, etc). The design goal is to utilise the powerfulness of existing ORMs as well as to separate domain logic (model behaviour) from data persistence.

Datamappify consists of three components:

- __Entity__ contains models behaviour, think an ActiveRecord model with the persistence specifics removed.
- __Data__ as the name suggests, holds your model data. It is an ORM object (ActiveRecord and Sequel, etc).
- __Repository__ is responsible for data retrieval and persistence, e.g. `find`, `save` and `destroy`, etc.

Note: Datamappify is NOT affiliated with the [Datamapper](https://github.com/datamapper/) project.

### Supported ORMs for Persistence

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

#### Retrieving entities

Pass in an id or an array of ids.

```ruby
user  = UserRepository.find(1)
users = UserRepository.find([1, 2, 3])
```

#### Saving/updating entities

Pass in an entity or an array of entities.

There is also `save!` that raises `Datamappify::Data::EntityNotSaved`.

```ruby
UserRepository.save(user)
UserRepository.save([user, user2, user3])
```

#### Destroying an entity

Pass in an entity, an id, an array of entities or an array of ids.

There is also `destroy!` that raises `Datamappify::Data::EntityNotDestroyed`.

Note that due to the attributes mapping, any data found in mapped ActiveRecord objects are not touched.

```ruby
UserRepository.destroy(1)
UserRepository.destroy([1, 2, 3])
UserRepository.destroy(user)
UserRepository.destroy([user, user2, user3])
```

## Changelog

Refer to [CHANGELOG](CHANGELOG.md).

## Todo

- Track dirty entity attributes.
- Attribute lazy-loading.
- Hooks for persistence (`before_save` and `after_save`, etc).
- [Authoritative source](http://msdn.microsoft.com/en-au/library/ff649505.aspx).
- Enforce attribute type casting.
- Support for configurable primary keys and foreign keys.

## Similar Projects

- [Curator](https://github.com/braintree/curator)
- [Edr](https://github.com/nulogy/edr)
- [Minimapper](https://github.com/joakimk/minimapper)

## Credits

- [Fred Wu](http://fredwu.me/) - author.
- [James Ladd](http://jamesladdcode.com/) for reviewing the code and giving advice on architectural decisions.
- [Locomote](http://www.locomote.com.au/) - where Datamappify is built and being tested in product development.

## License

Licensed under [MIT](http://fredwu.mit-license.org/)
