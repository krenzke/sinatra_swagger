require 'sinatra_swagger/version'
require 'sinatra_swagger/sinatra_exts'
require 'sinatra_swagger/cli'
require 'yard'

module SinatraSwagger
  YARD::Tags::Library.define_tag('API Parameter', :api_param, :with_types_and_name)

  DEFAULT_API_HASH = {
    swagger: "2.0",
    host: "petstore.swagger.io",
    basePath: "/v2",
    schemes: ["http"],
    paths: {}
  }

  # register a handler with Yard
  # TODO will this interfer with normal yard operation if someone
  # includes this gem and then calls yard?
  class ApiParseHandler < YARD::Handlers::Ruby::Base
    handles :class
    handles method_call(:get)
    handles method_call(:put)
    handles method_call(:post)
    handles method_call(:delete)
    handles method_call(:patch)
  end

  def self.root
    File.dirname __dir__
  end
end
