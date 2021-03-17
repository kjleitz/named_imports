# frozen_string_literal: true

require_relative "named_imports/version"

module NamedImports
  class Error < StandardError; end

  class << self
    def from(path, constants)
      ext = %r{[^/]+\.[^/]+$}.match?(path) ? "" : ".rb"
      path_with_ext = "#{path}#{ext}"
      caller_dir = File.dirname(caller(2..2).first)
      full_path = File.expand_path(path_with_ext, caller_dir)

      constants.each do |constant_name|
        Object.send(:remove_const, constant_name.to_sym)
        Object.autoload constant_name.to_sym, full_path
      end
    end

    def import
      constants = []

      begin
        yield
      rescue NameError => e
        raise e unless /uninitialized constant /.match?(e.message)

        constant_name = e.message.gsub(/uninitialized constant /, '').to_s
        already_there = constants.include?(constant_name)

        unless already_there
          constants << constant_name
          Object.const_set(constant_name, nil)
        end

        retry
      end

      constants
    end
  end

  Kernel.define_method(:from) do |path, constants|
    NamedImports.from(path, constants)
  end

  Kernel.define_method(:import) do |&block|
    NamedImports.import(&block)
  end
end
