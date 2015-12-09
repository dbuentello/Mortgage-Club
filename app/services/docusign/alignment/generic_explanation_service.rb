module Docusign
  module Alignment
    class GenericExplanationService
      attr_accessor :tabs

      def initialize(tabs)
        @tabs = tabs
      end

      def call
        # do something
        @tabs
      end
    end
  end
end
