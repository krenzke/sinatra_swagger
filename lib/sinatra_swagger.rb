require 'sinatra_swagger/version'
require 'sinatra_swagger/sinatra_exts'
require 'sinatra_swagger/cli'
require 'yard'

module SinatraSwagger
  YARD::Tags::Library.define_tag('API Parameter', :api_param, :with_types_and_name)
  YARD::Tags::Library.define_tag('API Version', :api_version)

  # register a handler with Yard
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
