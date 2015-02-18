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
      api_docs = {
        swagger: "2.0",
        schemes: ["http"],
        paths: {},
        info: {
          version: '1.0.0',
          title: '',
          description: '',
        },
      }


      # define the handler method, do it with a class_eval so
      # we have access to the surrounding scope and can modify
      # the 'api_docs' object
      ::SinatraSwagger::ApiParseHandler.class_eval do
        define_method(:process) do
          parsed_comments = YARD::Docstring.parser.parse(statement.comments)
          split_text = parsed_comments.text.split("\n\n")

          if statement.type == :class
            api_docs[:info][:title] = split_text[0]
            api_docs[:info][:description] = split_text.size > 1 ? split_text[1..-1].join("\n") : ''
            if version_tag = parsed_comments.tags.find{ |t| t.tag_name == 'api_version' }
              api_docs[:info][:version] = version_tag.text
            end
          else # an api endpoint
            route = statement.parameters(false).jump(:tstring_content).source
            verb  = statement.method_name(true).to_s

            summary = split_text[0]
            description = split_text.size > 1 ? split_text[1..-1].join("\n") : summary
            parameters = parsed_comments.tags.select{|t| t.tag_name == 'api_param' }.map do |t|
              {
                in: 'body',
                name: t.name,
                description: t.text,
                required: t.types.include?('requried'),
                type: t.types[0],
              }
            end

            api_docs[:paths][route] ||= {}
            api_docs[:paths][route][verb] = {
              summary: summary,
              description: description,
              parameters: parameters,
            }
          end
        end
      end

      # parse the input
      YARD.parse(@options[:input_file])

      # write to output, create directories if needed
      FileUtils.mkdir_p(File.dirname(@options[:output_file]))
      File.open(@options[:output_file], 'w') { |f| f.write(api_docs.to_json) }
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



