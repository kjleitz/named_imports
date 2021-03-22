# frozen_string_literal: true

from "class_which_uses_nonimported_code", import { OtherClass }

class ClassWhichUsesCodeFromAnotherImport
  def self.other_class_method
    OtherClass.some_method
  end

  def self.parent_importer_method_should_error
    ClassWhichUsesCodeFromMultilevelImport.multilevel_imported_class_method
  end
end

