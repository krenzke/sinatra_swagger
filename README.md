# SinatraSwagger

Parse your [Sinatra](http://www.sinatrarb.com/) apps source code and generate [Swagger 2.0](http://swagger.io/) documentation automatically.

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra_swagger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra_swagger

## Usage

### Generate Swagger Docs
SinatraSwagger will parse any source file you ask it to and generate a swagger.json from the docstrings of the api paths. To use the default options just run

    $ bundle exec sinswag

from the apps root directory. By default  it looks for an `app.rb` file to parse, and generates a `public/swagger.json`. These defaults can be changed by using the `--input PATH` and `--output PATH` options.

### Docstring Format and Tags
Swagger docs are generated by parsing the docstring for each defined route in your Sinatra app. The basic [Yard](http://yardoc.org/) doc format is used, but with a couple of extra tags specific to APIs. As an example:

```ruby
##
# Endpoint Summary
#
# Endpoint Description
#
# @api_param [String, required] param_name this is the description
get '/' do
  ...your code...
end
```

You can also document the main class and SinatraSwagger will pull the API title, description, and version from the docstring.

```ruby
##
# The Title of My Awesome App
#
# A longer description of my API which
# can wrap multiple lines.
#
# @api_version 1.2
class MyApp < Sinatra::Base
  enable_swagger_doc_endpoint
end
```

### Add Swagger UI to Your App
SinatraSwagger includes the basic [Swagger UI](https://github.com/swagger-api/swagger-ui). To enable the necessary routes just add a call to `enable_swagger_doc_endpoint` in your Sinatra app.

```ruby
class MyApp < Sinatra::Base
  enable_swagger_doc_endpoint
end
```

The default is to use the path `/api-docs`, but this can be changed by passing a `path: '/your_path'` options to the method call.

```ruby
class MyApp < Sinatra::Base
  enable_swagger_doc_endpoint path: '/foo-docs'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
