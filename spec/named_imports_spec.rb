# frozen_string_literal: true

require "spec_helper"

from './support/foobar', import { Foobar }
from './support/barbaz_and_bazbam', import { Barbaz }
from './support/bamxyz_and_xyzqwe_and_qwerty', import { Qwerty; Xyzqwe }

RSpec.describe NamedImports do
  it "has a version number" do
    expect(NamedImports::VERSION).not_to be nil
  end

  it "imports a single class from a file with a single class defined" do
    expect(Foobar.baz).to eq(true)
  end

  it "does not import a non-specified class from a file with multiple classes defined, if the non-specified class is used before the specified class" do
    expect { Bazbam.xyz }.to raise_error(NameError)
  end

  it "imports a single class from a file with multiple classes defined" do
    expect(Barbaz.bam).to eq(false)
  end

  it "unfortunately DOES import a non-specified class from a file with multiple classes defined once the specified class is used" do
    expect(Bazbam.xyz).to eq([])
  end

  it "does not import non-specified classes when importing multiple classes from a file with multiple classes defined, if the non-specified class is used before any of the specified classes" do
    expect { Bamxyz.qwe }.to raise_error(NameError)
  end

  it "imports multiple classes from a file with multiple classes defined" do
    expect(Xyzqwe.rty).to eq({})
    expect(Qwerty.uio).to eq("hi")
  end

  it "unfortunately DOES import non-specified classes from a file with multiple classes defined once one of the specified classes has been used" do
    expect(Bamxyz.qwe).to eq(123)
  end
end
