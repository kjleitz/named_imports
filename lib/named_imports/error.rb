# frozen_string_literal: true

module NamedImports
  module Error
    class Base < ::StandardError
    end

    class ImportBlockError < NamedImports::Error::Base
      def initialize(importer_file, importer_line, original_error = nil)
        error_details = []
        error_details << "Something went wrong when evaluating the named import at #{importer_file}:#{importer_line}."
        error_details << "This is likely to be an error in your 'import' block."
        if original_error
          original_error_class = original_error.class.to_s
          article = original_error_class[0].match(/aeiou/i) ? "an" : "a"
          error_details << "The original error was #{article} #{original_error_class}: #{original_error.message}"
        end

        error_message = error_details.join(" ")
        super(error_message)

        set_backtrace(original_error.backtrace) if original_error
      end
    end

    class ImportError < ::NameError
    end

    class ConstantImportError < NamedImports::Error::ImportError
      def initialize(imported_name, imported_file, importer_file, importer_line)
        super("Unable to import #{imported_name} from #{imported_file} (import occurs in #{importer_file}:#{importer_line})")
      end
    end
  end
end
