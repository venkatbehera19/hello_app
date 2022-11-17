# Ruby on Rails Tutorial sample application
This is the sample application for
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](https://www.railstutorial.ord/ ) (6th Edition)
by [Michael Hartl](https://www.michaelhartl.com/).
## License
All source code in the [Ruby on Rails Tutorial](https://www.railstutorial.org/) is available jointly under the MIT License and the Beerware License. See [LICENSE.md](LICENSE.md) for details.
## Getting started
To get started with the app, clone the repo and then install the needed gems:
a
S$ bundle install --without production
Pi a eae
Next, migrate the database:
ma
S$ rails db:migrate
a ee
Finally, run the test suite to verify that everything is working correctly:
~~ SN S
S rails test
~ &
If the test suite passes, you'll be ready to run the app in a local server:
~~ N NS
S rails server
~~ SN NS
For more information, see the [*Ruby on Rails Tutorial* book] (https://www.railstutorial.org/book).

## Generate Static pages
$ rails generate controller StaticPages home help

## Delete Static pages
$ rails destroy controller StaticPages home help

## Generate model
$ rails generate model User name:string email:string

## Destroy model
$ rails destroy model User 

## DB migration
$ rails db:migrate
## DB Rollback
$ rails db:rollback

## DB rollback to version 0
$ rails db:migrate VERSION=0

## Reset Database 
$ rm -f development.sqlite3 the rails db:migrate

## for pagination we need to add 2 gem
$ -> 1. gem 'will_paginate', '3.1.8'.    2. gem 'bootstrap-will_paginate', '1.0.0'

## add a column admin to the users table
$ rails g migration add_admin_to_users admin:boolean

## how to reset the DB
$ rails db:migrate:reset

## generate model of Post
$ rails generate model Post content:text user:references
## if we wants to retrive all post associated with user_id in reverse_order add below in migration
- add_index :posts, [:user_id, :created_at] 

## photo upload
$ rails active_storage:install