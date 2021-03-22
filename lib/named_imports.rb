# frozen_string_literal: true

require_relative "named_imports/version"

module NamedImports
  class Error < StandardError; end

  class << self
    def from(path, constants, context = Object)
      path_where_import_occurs = caller(2..2).first
      full_path = full_path_for_import(path, path_where_import_occurs)

      File.open(full_path, "r") do |file|
        file_content = file.read
        anon_mod = Module.new

        anon_mod.define_singleton_method(:from) do |path, constants|
          NamedImports.from(path, constants, anon_mod)
        end

        anon_mod.define_singleton_method(:import) do |&block|
          NamedImports.import(&block)
        end

        anon_mod.class_eval(file_content, full_path)

        constants.each do |constant_name|
          context.send(:remove_const, constant_name) if context.const_defined?(constant_name, false)
          context.const_set(constant_name, anon_mod.const_get(constant_name))
        end
      end
    end

    def import(context = Object)
      constants = []

      begin
        yield
      rescue NameError => e
        raise e unless /uninitialized constant /.match?(e.message)

        constant_match = e.message.match(/uninitialized constant (?:#<Module:[^>]+>::)?(\w*(?:::\w+)*)$/)
        constant_name = constant_match && constant_match[1]

        if constant_name.nil?
          raise NameError, "unable to import constant: #{e.message.gsub(/uninitialized constant /, '')}"
        end

        already_there = constants.include?(constant_name)

        unless already_there
          constants << constant_name
          context.const_set(constant_name, nil)
        end

        retry
      end

      constants
    end

    private

    def full_path_for_import(imported_path, importer_path)
      ext = %r{[^/]+\.[^/]+$}.match?(imported_path) ? "" : ".rb"
      imported_path_with_ext = "#{imported_path}#{ext}"
      importer_dir = File.dirname(importer_path)
      File.expand_path(imported_path_with_ext, importer_dir)
    end
  end

  Object.define_method(:from) do |path, constants|
    NamedImports.from(path, constants)
  end

  Object.define_method(:import) do |&block|
    NamedImports.import(&block)
  end
end
