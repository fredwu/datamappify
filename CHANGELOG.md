## master

- __Completed rewritten Repository__
  - Repository now handles data construction from different ORM objects
  - ActiveRecord has now been demoted to being a data provider, it no longer tightly couples with Repository, this means __we could have multiple data providers__!
  - Repository is now much more robust
  - As a result of the more robust system, it fixed an issue where updating an existing entity with new data records from mapped attributes will not persist the new data records correctly

## 0.10.1 [2013-03-16]

- Fixed `#save` for creating new objects.
- `#save` now performs in a transaction.

## 0.10.0 [2013-03-16]

- Refactored `Repository`. `Entity` can now have attributes sourced from different `Data` objects.
- Removed relationships support - the effort required to make it work is not worth it.

## 0.9.0 [2013-03-14]

- A total rewrite as a proof-of-concept based on the repository pattern.
