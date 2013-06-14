require 'forwardable'
require_relative 'icon'

module Grocer
  module Pushpackager
    class IconSet
      include Enumerable
      extend Forwardable
      def_delegators :@icons, :each, :<<
      
      def initialize(config = {})
        raise ArgumentError, "Missing icon set" unless config[:iconSet]
        @icons = []
        config[:iconSet].each do |size, file|
          @icons << Icon.new(size).from_file(file)
        end
      end

      def valid?
        fail unless @icons.select{|i| i.valid?}.count == @icons.count 
      end
    end
  end
end
