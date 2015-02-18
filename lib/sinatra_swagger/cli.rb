require 'json'
require 'optparse'
require 'fileutils'

module SinatraSwagger
  class CLI
    def self.run(*args)
      new.run(*args)
    end

    def initialize
      @options = {
        input_file: 'app.rb',
        output_file: './public/swagger.json',
      }
    end

    def run(*args)
      parse_options(*args)

      # for storing all the path info we're going to parse
      paths = {}

      # define the handler method, do it with a class_eval so
      # we have access to the surrounding scope and can modify
      # the 'paths' object
      ::SinatraSwagger::ApiParseHandler.class_eval do
        define_method(:process) do
          parsed_comments = YARD::Docstring.parser.parse(statement.comments)
          route = statement.parameters(false).jump(:tstring_content).source
          verb  = statement.method_name(true).to_s
          paths[route] ||= {}
          paths[route][verb] = {
            description: parsed_comments.text,
          }
        end
      end

      # parse the input
      YARD.parse(@options[:input_file])

      # write to output, create directories if needed
      FileUtils.mkdir_p(File.dirname(@options[:output_file]))
      File.open(@options[:output_file], 'w') { |f| f.write(DEFAULT_API_HASH.merge(paths: paths).to_json) }
    end

    def parse_options(*args)
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: sinswag [options]"
        opts.on('--input PATH', 'specify input file (defaults to ./app.rb)') do |in_file|
          @options[:input_file] = in_file
        end
        opts.on('--output PATH', 'specify output file (defaults to ./public/swagger.json)') do |out_file|
          @options[:output_file] = out_file
        end
        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end
      parser.parse!(args)
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
      puts e.to_s
      puts parser
      exit
    end
  end
end



