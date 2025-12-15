#!/usr/bin/env ruby
# frozen_string_literal: true

# Usage examples:
#   ruby lang_scaffold.rb scaffold
#   ruby lang_scaffold.rb scaffold languages.csv --root=.
#
# CSV format (no header expected by default):
#   language,service_type,port
# Example:
#   java,proxy,8009
#   perl,fastcgi,8005
#   fortran,proxy,8008

# TODO: Rename Language references to App

require 'thor'
require 'thor/actions'
require 'csv'

class LangScaffold < Thor
  include Thor::Actions

  # Where Thor::Actions looks for templates
  def self.source_root
    File.expand_path('templates', __dir__)
  end

  class_option :root,
               aliases: '-r',
               type: :string,
               default: '.',
               desc: 'Root output directory for generated files'

  desc 'scaffold [CSV_PATH]',
       'Generate per-language folders, Dockerfiles, nginx configs, and docker-compose.yml from CSV'
  method_option :compose,
                type: :boolean,
                default: true,
                desc: 'Generate root docker-compose.yml'
  method_option :dockerfiles,
                type: :boolean,
                default: true,
                desc: 'Generate Dockerfiles for each language'
  method_option :nginx,
                type: :boolean,
                default: true,
                desc: 'Generate NGINX sites-available configs'

  def scaffold(csv_path = 'languages.csv')
    languages = load_languages(csv_path)

    if languages.empty?
      say_status :error, "No valid rows found in CSV: #{csv_path}", :red
      exit 1
    end

    say_status :info, "Loaded #{languages.size} language entries", :blue

    generate_compose(languages)     if options[:compose]
    generate_dockerfiles(languages) if options[:dockerfiles]
    generate_nginx(languages)       if options[:nginx]
  end

  no_commands do
    # Parse CSV into an array of hashes:
    # [{ name: "java", service_type: "proxy", port: "8009" }, ...]
    def load_languages(csv_path)
      unless File.exist?(csv_path)
        say_status :error, "CSV file not found: #{csv_path}", :red
        exit 1
      end

      languages = []

      CSV.foreach(csv_path, headers: true) do |row|
        next if row.to_h.values.compact.all?(&:empty?)

        name  = row['language'].to_s.strip.downcase
        type  = row['service_type'].to_s.strip.downcase
        port  = row['port'].to_s.strip.to_i
        tmpl  = row['docker_template'].to_s.strip.downcase

        next if name.empty?

        type = 'proxy' if type.empty?
        port = '9000'  if port.empty?

        languages << {
          name: name,
          service_type: type,
          port: port,
          docker_template: tmpl
        }
      end

      languages
    end

    def generate_docker_compose(languages)
      say_status :compose, 'Generating docker-compose.yml...', :green

      destination = File.join(options[:root], 'docker-compose.yml')
      template('docker-compose.yml.erb', destination, languages: languages)
      say_status :create, 'docker-compose.yml', :green
    end

    def generate_dockerfiles(languages)
      say_status :docker, 'Generating Dockerfiles...', :green

      languages.each do |lang|
        lang_dir = File.join(options[:root], lang[:name])
        empty_directory lang_dir

        destination = File.join(lang_dir, 'Dockerfile')

        if File.exist?(destination)
          say_status :skip, "Dockerfile exists for #{lang[:name]} at #{destination}", :yellow
          next
        end

        # Choose template key:
        # 1. docker_template column (if provided)
        # 2. language name
        # 3. fall back to "generic"
        template_key = begin
          lang[:docker_template].presence
        rescue StandardError
          nil
        end || lang[:name]
        template_key = template_key.to_s.downcase

        template_name = "Dockerfile.#{template_key}.erb"
        template_name = 'Dockerfile.generic.erb' unless template_exists?(template_name)

        unless template_exists?(template_name)
          say_status :error, "No Dockerfile template found for #{lang[:name]} (tried #{template_name})", :red
          next
        end

        template(template_name, destination, lang)
        say_status :create, "Dockerfile for #{lang[:name]} (port=#{lang[:port]}, template=#{template_name})", :green
      end
    end

    def generate_nginx_main(languages)
      nginx_root = File.join(options[:root], "nginx")
      www_root   = File.join(nginx_root, "www")

      empty_directory nginx_root
      empty_directory www_root

      # Main nginx.conf
      template("nginx.conf.erb", File.join(nginx_root, "nginx.conf"), languages: languages)

      # index.html
      template("index.html.erb", File.join(www_root, "index.html"), languages: languages)

      say_status :create, "nginx/nginx.conf and nginx/www/index.html", :green
    end

    def generate_nginx_sites(languages)
      say_status :nginx, "Generating NGINX conf.d configs...", :green

      conf_root = File.join(options[:root], "nginx", "conf.d")
      empty_directory conf_root

      languages.each do |lang|
        destination = File.join(conf_root, "#{lang[:name]}.conf")
        template("nginx_site.conf.erb", destination, lang)
        say_status :create, "nginx/conf.d/#{lang[:name]}.conf", :green
      end
    end

    def template_exists?(filename)
      File.exist?(File.join(self.class.source_root, filename))
    end
  end
end

LangScaffold.start(ARGV)
