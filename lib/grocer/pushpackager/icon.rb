module Grocer
  module Pushpackager
    class Icon
      attr_reader :name, :contents
      def initialize(size)
        @name = "icon_#{size}.png"
        self
      end

      def from_file file
        @contents = file.read
        file.close
        self
      end

      def valid?
        raise ArgumentError, "invalid icon name" unless @name
        raise ArgumentError, "missing contents" unless @contents
        true
      end
    end
  end
end
