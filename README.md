# NamedImports

Ever look at a class in a Ruby file and wonder _"Where the hell did that come from?"_ If you have, then this might ease your pain. 

## Installation

### Locally (to your application)

Add the gem to your application's `Gemfile`:

```ruby
gem 'named_imports'
```

...and then run:

```bash
bundle install
```

### Globally (to your system)

Alternatively, install it globally:

```bash
gem install named_imports
```

## Usage

Require the `named_imports` gem in the entrypoint of your project, or at whatever point you know you will need named imports in Ruby files evaluated after that point:


```rb
require 'named_imports'
```

Then, use named imports:

```rb
# ~/your_project/lib/foo.rb

class Foo
  def self.some_bool
    true
  end
end
```

```rb
# ~/your_project/lib/example.rb

from 'foo', import { Foo }

Foo.some_bool
#=> true
```

You can also specify which constant to import, which provides some safety that you don't try to access constants you haven't specified:

```rb
# ~/your_project/lib/whatever/bar_and_baz.rb

class Bar
  def self.some_int
    123
  end
end

class Baz
  def self.some_str
    "hi"
  end
end
```

```rb
# ~/your_project/lib/example.rb

from './whatever/bar_and_baz', import { Baz }

Bar.some_int
#=> NameError (uninitialized constant Bar)

Baz.some_str
#=> "hi"
```

> **Note:** Currently, non-specified constants defined in the imported file _will_ be available _after_ you've used one (or more) of the constants you specified in the import statement. Working on it!

You can import multiple constants as well, by separating them with a semicolon in the `import` block:

```rb
# ~/your_project/lib/whatever/bam_and_bop.rb

class Bam
  def self.some_ary
    []
  end
end

class Bop
  def self.some_hash
    {}
  end
end
```

```rb
# ~/your_project/lib/example.rb

from 'whatever/bam_and_bop.rb', import { Bam; Bop }

Bam.some_ary
#=> []

Bop.some_hash
#=> {}
```

## TODO

- [x] named constant imports
- [x] multiple constant imports
- [ ] top-level function imports
- [x] namespace should not be polluted with non-specified constants (before the specified import is referenced/used)
- [ ] namespace should not be polluted with non-specified constants (after the specified import is referenced/used)

## Development

### Install dependencies

```bash
bin/setup
```

### Run the tests

```bash
rake spec
```

### Run the linter

```bash
rubocop
```

### Create release

```
rake release
```

## Contributing

Bug reports and pull requests for this project are welcome at its [GitHub page](https://github.com/kjleitz/named_imports). If you choose to contribute, please be nice so I don't have to run out of bubblegum, etc.

## License

This project is open source, under the terms of the [MIT license.](https://github.com/kjleitz/named_imports/blob/master/LICENSE)

## Code of Conduct

Everyone interacting in the NamedImports project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kjleitz/named_imports/blob/master/CODE_OF_CONDUCT.md).
