# frozen_string_literal: true

class ClassWhichUsesNonimportedCode
  def self.other_class_method
    OtherClass.some_method
  end
end

class OtherClass
  def self.some_method
    "woo!"
  end
end
