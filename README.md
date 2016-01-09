# Nathan Hadzariga - www.nathanhadzariga.com


## Tech Stack

### Frameworks

* Ruby on Rails 4.X
* AngularJS 1.X

### Tools

* Minitest::Spec / Guard
* Jasmine / Karma
* Bower
* NPM



## Development Environment Setup

### System Requirements

* Ruby 2.2.4
* Bundler
* NPM
* Bower

### Configuration

* `bundle install` (ruby deps)
* `npm install` (front end dev deps)
* `bower install` (front end prod deps)
* `rake db:setup`
* (optional) create file `config/application.yml` with contents

    ```yml
      production:
        secret_key_base: actual-production-secret-key
    ```

* `rails s` to start up local development server on [localhost:3000](http://localhost:3000).

### Tests

* `guard` to run ruby tests and watch files for changes (`quit` to stop)
* `karma start` to run front end tests and watch JS files for changes (`ctrl-c` to stop)




## Deployment

(Coming soon)
