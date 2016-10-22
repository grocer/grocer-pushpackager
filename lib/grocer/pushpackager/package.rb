require 'zip/zip'
require 'digest/sha1'
require 'openssl'
require_relative 'icon_set'
require_relative 'website'

module Grocer
  module Pushpackager
    class Package
      attr_accessor :key, :certificate, :icon_set, :website

      def initialize(config = {})
        @icon_set = IconSet.new(config)
        @website = Website.new(config)
        @certificate = config[:certificate]
        @additional_certs = config[:additional_certs] || []
        @key = config[:key]
      end

      def authentication_token= value
        @website.authentication_token = value
        @signature = nil
        @website_json = nil
        @manifest_json = nil
      end

      def valid?
        @icon_set.valid?
        @website.valid?
        raise ArgumentError, "Missing private key" unless @key
        raise ArgumentError, "Missing certificate" unless @certificate
        true
      end

      def file
        raise unless self.valid?
        package = Tempfile.new('package')
        package.write(build_zip.string)
        package.close
        package
      end

      def buffer
        raise unless self.valid?
        build_zip.string
      end

      private
      def website_json
        @website_json ||= @website.to_json
      end

      def manifest_json
        return @manifest_json if @manifest_json
        @manifest_json = {
          :"website.json" => Digest::SHA1.hexdigest(website_json)
        }.merge(icon_set_manifest).to_json
      end

      def icon_set_manifest
        manifest = { }
        @icon_set.each do |icon|
          manifest[:"icon.iconset\/#{icon.name}"] = Digest::SHA1.hexdigest(icon.contents)
        end
        manifest
      end

      def signature
        return @signature if @signature
        @signature = OpenSSL::PKCS7::sign(@certificate, @key, manifest_json, @additional_certs, OpenSSL::PKCS7::DETACHED)
      end

      def build_zip
        buffer = Zip::ZipOutputStream.write_buffer do |out|
          @icon_set.each do |icon|
            out.put_next_entry("icon.iconset/#{icon.name}")
            out.write icon.contents
          end
          out.put_next_entry('website.json')
          out.write website_json
          out.put_next_entry('manifest.json')
          out.write manifest_json
          out.put_next_entry('signature')
          out.write signature.to_der
        end
        buffer
      end
    end
  end
end
