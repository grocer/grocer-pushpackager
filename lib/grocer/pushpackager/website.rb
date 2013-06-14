require 'uri'
require 'json'

module Grocer
  module Pushpackager
    class Website
      attr_accessor :authentication_token
      attr_reader :website_name, :push_id, :allowed_domains, :url_format_string, :web_service_url
      
      def initialize(config = {})
        @website_name = config[:websiteName]
        @push_id = config[:websitePushID]
        @allowed_domains = []
        if config[:allowedDomains]
          @allowed_domains = config[:allowedDomains].map{|domain| URI(domain)}
        end
        @url_format_string = config[:urlFormatString]
        @web_service_url = URI(config[:webServiceURL])
        @authentication_token = config[:authenticationToken]
      end

      def valid?
        raise ArgumentError if not @website_name or @website_name.empty?
        raise ArgumentError if not @push_id or @push_id.empty? 
        raise ArgumentError if not @url_format_string or @url_format_string.empty?
        raise ArgumentError if not @web_service_url or @web_service_url.to_s.empty? or not ['http', 'https'].include?(@web_service_url.scheme)
        raise ArgumentError if not @authentication_token or @authentication_token.empty?
        raise ArgumentError, "Allowed domains" unless @allowed_domains.count > 0
        true
      end

      def to_json
        raise "Invalid website" unless valid?
        { websiteName: @website_name.to_s,
          websitePushID: @push_id.to_s,
          allowedDomains: @allowed_domains.map{|domain| domain.to_s},
          urlFormatString: @url_format_string.to_s,
          authenticationToken: @authentication_token.to_s,
          webServiceURL: @web_service_url.to_s,
        }.to_json
      end
    end
  end
end
