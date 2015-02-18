if defined?(Sinatra)
  class Sinatra::Base
    def self.enable_swagger_doc_endpoint(options = {})
      path = options[:path] || '/api-docs'
      get path do
        send_file File.join(SinatraSwagger.root, 'web', 'api_index.html')
      end

      # handle swagger ui assets
      get %r{/.+\.[css|js|png|gif|eot|svg|ttf|woff|woff2]} do
        full_path = File.join(SinatraSwagger.root, 'web', request.path)
        if File.exist?(full_path)
          send_file full_path
        else
          pass
        end
      end
    end
  end
end
