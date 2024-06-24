module RubyLsp
  module Standard
    class WrapsBuiltinLspStandardizer
      include RubyLsp::Requests::Support::Formatter
      def initialize
        init!
      end

      def init!
        @config = ::Standard::BuildsConfig.new.call([])

        @standardizer = ::Standard::Lsp::Standardizer.new(
          @config,
          ::Standard::Lsp::Logger.new
        )
      end

      def run_formatting(uri, document)
        @standardizer.format(uri_to_path(uri), document.source)
      end

      def run_diagnostic(uri, document)
        @standardizer.offenses(uri_to_path(uri), document.source, document.encoding)
      end

      private

      # duplicated from: lib/standard/lsp/routes.rb
      # modified to incorporate Ruby LSP's to_standardized_path method
      def uri_to_path(uri)
        if uri.respond_to?(:to_standardized_path) && !(standardized_path = uri.to_standardized_path).nil?
          standardized_path
        else
          uri.to_s.sub(%r{^file://}, "")
        end
      end
    end
  end
end
