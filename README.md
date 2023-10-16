# Pod

TODO: create pod description

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pod

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pod

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### TODO List
- [x] Input interpretation
     - [x] Create abstraction for `Open3`
- [x] `pod version/-v/--version` command
- [ ] `pod init` command
- [ ] Setup linter
- [ ] Setup lefthook
- [ ] Setup CI

### File structure

```
.
└── lib/
    ├── pod/
    │   ├── commands/
    │   │   ├── init/
    │   │   │   ├── runner.rb
    │   │   │   └── output.rb
    │   │   ├── add/
    │   │   │   ├── runner.rb
    │   │   │   └── output.rb
    │   │   ├── archive/
    │   │   │   ├── runner.rb
    │   │   │   └── output.rb
    │   │   └── ...
    │   ├── infrastructure/
    │   │   ├── feed_parser.rb
    │   │   ├── shell_interface.rb
    │   │   ├── dto.rb
    │   │   ├── storage.rb
    │   │   └── ...
    │   └── cli.rb
    └── pod.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gustavothecoder/pod.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
