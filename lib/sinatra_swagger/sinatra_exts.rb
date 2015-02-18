if defined?(Sinatra)
  class Sinatra::Base
    def self.swagger_doc_endpoint
      get '/foo' do
        'foobatr'
      end
    end
  end
end
