#!/usr/bin/ruby
# frozen_string_literal: true

# Usage:
#   ruby generate_nginx_sites.rb languages.csv [output_root]
#
# Example CSV (languages.csv):
#   java,proxy
#   perl,fastcgi
#   fortran,proxy
#
# This will create:
#   output_root/
#     java/java.conf
#     perl/perl.conf
#     fortran/fortran.conf

require "csv"
require "fileutils"

csv_path    = ARGV[0] || "languages.csv"
output_root = ARGV[1] || "nginx_sites"

unless File.exist?(csv_path)
  warn "CSV file not found: #{csv_path}"
  exit 1
end

FileUtils.mkdir_p(output_root)

def proxy_config(lang, port = 9000)
  upstream_name = "#{lang}_app"

  <<~NGINX
    # Auto-generated NGINX reverse proxy config for #{lang}
    upstream #{upstream_name} {
        server 127.0.0.1:#{port};
    }

    server {
        listen 80;
        server_name _;

        # Example URL: http://localhost/#{lang}/
        location /#{lang}/ {
            proxy_pass http://#{upstream_name}/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
  NGINX
end

def fastcgi_config(lang)
  socket_path = "/run/#{lang}.sock"

  <<~NGINX
    # Auto-generated NGINX FastCGI config for #{lang}
    server {
        listen 80;
        server_name _;

        # Example URL: http://localhost/#{lang}/script.cgi
        location /#{lang}/ {
            include fastcgi_params;
            fastcgi_pass unix:#{socket_path};
            fastcgi_param SCRIPT_FILENAME /var/www/#{lang}$fastcgi_script_name;
        }
    }
  NGINX
end

def generic_config(lang)
  <<~NGINX
    # Auto-generated NGINX config for #{lang}
    # Service type not recognized; customize this file as needed.

    server {
        listen 80;
        server_name _;

        location /#{lang}/ {
            return 200 "Hello from #{lang} (generic config)\\n";
        }
    }
  NGINX
end

CSV.foreach(csv_path, headers: false) do |row|
  next if row.compact.empty?

  lang = row[0].to_s.strip.downcase
  type = row[1].to_s.strip.downcase

  next if lang.empty?

  lang_dir   = File.join(output_root, lang)
  config_path = File.join(lang_dir, "#{lang}.conf")

  FileUtils.mkdir_p(lang_dir)

  config_content =
    case type
    when "proxy"
      # You can tweak the default backend port per language if needed
      proxy_config(lang, 9000)
    when "fastcgi"
      fastcgi_config(lang)
    else
      generic_config(lang)
    end

  File.write(config_path, config_content)
  puts "Generated config for #{lang} (type=#{type}) at #{config_path}"
end

