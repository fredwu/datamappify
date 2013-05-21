## master

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
