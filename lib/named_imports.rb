# frozen_string_literal: true

require_relative "named_imports/version"
require_relative "named_imports/error"

module NamedImports
  @@sandboxes = {}

  class << self
    def from(raw_path, constant_names, context = Object)
      into_path, import_line = caller_path_and_line
      from_path = full_path_for_import(from_path: raw_path, into_path: into_path)
      sandbox = sandbox_eval(file_path: from_path)
      load_constants(constant_names, from_sandbox: sandbox, into_context: context)
    end

    def import(context = Object, &block)
      into_path, import_line = caller_path_and_line
      constant_names = []

      begin
        block.call
      rescue => e
        constant_name = constant_name_from_error(e)

        if constant_name.nil?
          raise NamedImports::Error::ImportBlockError.new(into_path, import_line, e)
        end

        if !constant_names.include?(constant_name)
          constant_names << constant_name
          context.const_set(constant_name, nil)
        end

        retry
      end

      constant_names
    end

    def make_named_imports_available(in_context: Object)
      def_method = in_context == Object ? :define_method : :define_singleton_method

      in_context.send(def_method, :from) do |path, constants|
        NamedImports.from(path, constants, in_context)
      end

      in_context.send(def_method, :import) do |&block|
        NamedImports.import(in_context, &block)
      end
    end

    private

    def caller_path_and_line
      caller_path_info = caller(3..3).first
      caller_path_info.match(/\A(.+?):(\d+):/)[1..2]
    end

    def full_path_for_import(from_path:, into_path:)
      ext = %r{[^/]+\.[^/]+$}.match?(from_path) ? "" : ".rb"
      from_path_with_ext = "#{from_path}#{ext}"
      importer_dir = File.dirname(into_path)
      File.expand_path(from_path_with_ext, importer_dir)
    end

    def catchable_missing_constant_error?(error)
      error.is_a?(NameError) && error.message =~ /uninitialized constant /
    end

    def constant_name_from_error(error)
      return unless error.is_a?(NameError)
      constant_matcher = /uninitialized constant (?:#<Module:[^>]+>::)?(\w*(?:::\w+)*)$/
      constant_match = error.message.match(constant_matcher)
      constant_match && constant_match[1]
    end

    def read_content(file_path:)
      File.open(file_path, &:read)
    end

    def sandbox_eval(file_path:)
      return @@sandboxes[file_path] if @@sandboxes[file_path]

      @@sandboxes[file_path] = Module.new
      sandbox_module = @@sandboxes[file_path]
      make_named_imports_available(in_context: sandbox_module)
      ruby_code = read_content(file_path: file_path)
      sandbox_module.class_eval(ruby_code, file_path)
      sandbox_module
    end

    def load_constants(constant_names, from_sandbox:, into_context:)
      constant_names.each do |constant_name|
        if into_context.const_defined?(constant_name, false)
          into_context.send(:remove_const, constant_name)
        end

        sandboxed_constant = from_sandbox.const_get(constant_name)
        into_context.const_set(constant_name, sandboxed_constant)
      end
    end
  end

  make_named_imports_available
end
