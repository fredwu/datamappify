## master

- Proper dirty tracking in record updating, fixes an issue of setting an attribute to `nil`.
- Added `has_one` association.
- Added `before_load`, `after_load`, `before_find` and `after_find` callbacks.
- Added `before_init` and `after_init` callbacks.

## 0.70.0.beta1 [2013-09-26]

- Fixed dirty tracking for entities returned from `where` and `all`.
- Fixed a bug where in certain situations duplicated data records are created upon updating an entity.
- Fixed a bug where reversed mapping option `:via` generates wrong join queries.
- New API: Added `match` for repository.
- Added preliminary support for composed search criteria.
  - Added `where` as a composable criteria.
  - Added `match` as a composable criteria.
  - Added `limit` as a composable criteria.
  - Added `order` as a composable criteria.
- Added experimental support for associations.
  - Added `reference_key` option to `map_attribute`.
  - Added support for ActiveRecord-style attribute-nesting, e.g. `form.fields_for`.
  - Added validation aggregation for associated entities.
  - Added the ability to destroy associated items.
- Performance optimisations.
  - Refactored the way Datamappify walks attributes to allow query optimisations.
  - Optimised ActiveRecord queries for entities.

## 0.60.0 [2013-07-23]

- New API: Introduced `Datamappify.config` for configuring default behaviours.
- API change: `where` now replaces `find` for multiple items.
- API change: `map_attribute` now takes `:to` and `:provider` instead of a string for specifying data source.
- New API: Introduced `group` for grouping `map_attribute`.
- Added support for entity namespaces (closes #4).

## 0.53.2 [2013-07-18]

- Better attributes inspect. Thanks @jamesmoriarty!
- Added support of `:create` and `:update` contexts for validations.
- Fixed the persistence when `:via` is specified in the repository.

## 0.53.1 [2013-06-27]

- Fixed ruby 1.9 compatibility.

## 0.53.0 [2013-06-27]

- Added support for mapping to namespaced data models.

## 0.52.0 [2013-06-26]

- Added support for reverse mapping attributes.

## 0.51.1 [2013-06-17]

- Fixed an issue with attribute name and validation conflicts.

## 0.51.0 [2013-06-17]

- Enhanced `find` for searching specific attributes.
- Added support for repository inheritance.
- `attributes_from` now copies validations as well!
- `find` now raises an exception if the arguments contain an unknown attribute key.

## 0.50.0 [2013-05-30]

- Added `all` to repository.
- Added `PersistentStates#mark_as_dirty`.
- Added `Entity#references`.
- Implemented nested composable entities!

## 0.40.0 [2013-05-21]

- Added dirty attribute tracking.
- Implemented attribute lazy loading!
- Query methods (`find`, `save` and `destroy`) no longer support multiple entities.
  - e.g. `UserRepository.find([1, 2, 3])` is no longer valid.
- Added `exists?`, `create`, `create!`, `update` and `update!` to repository.
- Implemented callbacks (e.g. `before_save` and `after_save`, etc).

## 0.30.0 [2013-04-12]

- __Completely reimplemented Datamappify__
  - Things are more decoupled and cleaner in general.
- Leaner `Repository` syntax, i.e. `UserRepository` instead of the more verbose `UserRepository.instance`.

## 0.20.1 [2013-03-19]

- Fixed the leftover `require 'active_record'` in the code so the gem works without ActiveRecord.

## 0.20.0 [2013-03-19]

- __Completely rewritten Repository__
  - Repository now handles data construction from different ORM objects.
  - ActiveRecord has now been demoted to being a data provider, it is no longer tightly coupled with Repository, this means __we could have multiple data providers__!
  - Repository is now much more robust.
  - As a result of robustness, it fixed an issue where updating an existing entity with new data records from mapped attributes will not persist the new data records correctly.
  - `#save` and `#destroy` now support accepting an array as their argument.
  - Added support for Sequel!
  - Added support for mapping entity attributes to different ORMs!

## 0.10.1 [2013-03-16]

- Fixed `#save` for creating new objects.
- `#save` now performs in a transaction.

## 0.10.0 [2013-03-16]

- Refactored `Repository`. `Entity` can now have attributes sourced from different `Data` objects.
- Removed relationships support - the effort required to make it work is not worth it.

## 0.9.0 [2013-03-14]

- A total rewrite as a proof-of-concept based on the repository pattern.
