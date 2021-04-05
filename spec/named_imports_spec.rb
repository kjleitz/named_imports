# frozen_string_literal: true

require "spec_helper"

# Import using DOT-SPECIFIED relative path, WITH extension
from './support/foobar.rb', import { Foobar }
# Import using NO DOT (treat as dot-slash) relative path, WITH extension
from 'support/barbaz_and_bazbam.rb', import { Barbaz }
# Import using DOT-SPECIFIED relative path, WITHOUT extension
from './support/bamxyz_and_xyzqwe_and_qwerty', import { Qwerty; Xyzqwe }
# Import using NO DOT (treat as dot-slash) relative path, WITHOUT extension
from 'support/class_which_uses_nonimported_code', import { ClassWhichUsesNonimportedCode }
from 'support/class_which_uses_code_from_another_import', import { ClassWhichUsesCodeFromAnotherImport }
from 'support/class_which_uses_code_from_multilevel_import', import { ClassWhichUsesCodeFromMultilevelImport }

RSpec.describe NamedImports do
  it "has a version number" do
    expect(NamedImports::VERSION).not_to be nil
  end

  it "imports a single class from a file with a single class defined" do
    expect(Foobar.baz).to eq(true)
  end

  it "does not import a non-specified class from a file with multiple classes defined, if the non-specified class is used AFTER the specified class" do
    expect { Bazbam.xyz }.to raise_error(NameError)
  end

  it "imports a single class from a file with multiple classes defined" do
    expect(Barbaz.bam).to eq(false)
  end

  it "does not import a non-specified class from a file with multiple classes defined, even AFTER the specified class is used" do
    expect { Bazbam.xyz }.to raise_error(NameError)
  end

  it "does not import non-specified classes when importing multiple classes from a file with multiple classes defined, if the non-specified class is used before any of the specified classes" do
    expect { Bamxyz.qwe }.to raise_error(NameError)
  end

  it "imports multiple classes from a file with multiple classes defined" do
    expect(Xyzqwe.rty).to eq({})
    expect(Qwerty.uio).to eq("hi")
  end

  it "does not import non-specified classes from a file with multiple classes defined, even AFTER one of the specified classes has been used" do
    expect { Bamxyz.qwe }.to raise_error(NameError)
  end

  it "allows importing a class that calls a method of another class in the file (but which is not imported, itself)" do
    expect(ClassWhichUsesNonimportedCode.other_class_method).to eq("woo!")
    expect { OtherClass.some_method }.to raise_error(NameError)
  end

  it "allows importing a class that calls a method of another class it imports (but which is not imported, itself)" do
    expect(ClassWhichUsesCodeFromAnotherImport.other_class_method).to eq("woo!")
    expect { OtherClass.some_method }.to raise_error(NameError)
  end

  it "allows importing a class that calls a method of another class it imports (which itself uses an imported class)" do
    expect(ClassWhichUsesCodeFromMultilevelImport.multilevel_imported_class_method).to eq("woo!")
    expect { OtherClass.some_method }.to raise_error(NameError)
  end

  it "does not pollute multilevel-imported classes with imports from the child's scope" do
    expect {
      ClassWhichUsesCodeFromMultilevelImport.other_class_method_should_error
    }.to raise_error(NameError)
  end

  it "unfortunately DOES pollute imported child classes, in multilevel-imported classes, with the parent's scope... maybe not a bad thing, though?" do
    expect {
      ClassWhichUsesCodeFromMultilevelImport.child_class_method_using_parent_importer_should_error
    }.not_to raise_error
  end

  it "reports the correct error when an imported module has, like, a syntax error or whatever" do
    expect {
      from 'support/only_imports_only_imported_by_another_import',
        import { OnlyImportsOnlyImportedByAnotherImport }
    }.to raise_error(SyntaxError)
  end

  it "re-uses the same sandbox module for repeated imports from the same module" do
    from 'support/thing_that_imports_scoops', import { ThingThatImportsScoops }

    expect(ThingThatImportsScoops.scoops_class_counter).to be_zero
    expect(ThingThatImportsScoops.scoops_class_instance_counter).to be_zero

    ThingThatImportsScoops.increment_scoops_class_counter!

    expect(ThingThatImportsScoops.scoops_class_counter).to eq(1)
    expect(ThingThatImportsScoops.scoops_class_instance_counter).to eq(0)

    ThingThatImportsScoops.increment_scoops_class_instance_counter!

    expect(ThingThatImportsScoops.scoops_class_counter).to eq(1)
    expect(ThingThatImportsScoops.scoops_class_instance_counter).to eq(1)

    from 'support/scoops', import { Scoops }

    expect(ThingThatImportsScoops.scoops_class_counter).to eq(1)
    expect(ThingThatImportsScoops.scoops_class_instance_counter).to eq(1)
    expect(Scoops.class_counter).to eq(1)
    expect(Scoops.class_instance_counter).to eq(1)

    Scoops.increment_class_counter!

    expect(ThingThatImportsScoops.scoops_class_counter).to eq(2)
    expect(ThingThatImportsScoops.scoops_class_instance_counter).to eq(1)
    expect(Scoops.class_counter).to eq(2)
    expect(Scoops.class_instance_counter).to eq(1)

    Scoops.increment_class_instance_counter!

    expect(ThingThatImportsScoops.scoops_class_counter).to eq(2)
    expect(ThingThatImportsScoops.scoops_class_instance_counter).to eq(2)
    expect(Scoops.class_counter).to eq(2)
    expect(Scoops.class_instance_counter).to eq(2)
  end
end
