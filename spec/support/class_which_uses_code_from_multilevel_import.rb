# frozen_string_literal: true

from "class_which_uses_code_from_another_import", import { ClassWhichUsesCodeFromAnotherImport }

class ClassWhichUsesCodeFromMultilevelImport
  def self.hello
    "hi"
  end

  def self.multilevel_imported_class_method
    ClassWhichUsesCodeFromAnotherImport.other_class_method
  end

  def self.other_class_method_should_error
    OtherClass.some_method
  end

  def self.child_class_method_using_parent_importer_should_error
    ClassWhichUsesCodeFromAnotherImport.parent_importer_method_should_error
  end
end
