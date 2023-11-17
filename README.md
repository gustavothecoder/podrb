# Podrb

Simple CLI to manage podcasts.

https://github.com/gustavothecoder/podrb/assets/57065994/d7bc28cc-0cf5-428e-a2b1-e59e55ff09c0

## Installation

Podrb is a Ruby gem published on RubyGems, so you can install running:

```bash
$ gem install podrb
```

## Usage

### Initialization

```bash
$ podrb init
```

### Adding a podcast

```bash
$ podrb add ./path/to/rss.xml
$ podrb add https://podcast.com/feed.xml
```

### Listing podcasts

```bash
$ podrb podcasts
$ podrb podcasts --fields=id name
```

### Listing episodes

```bash
$ podrb episodes PODCAST_ID
$ podrb podcasts PODCAST_ID --fields=id title duration
$ podrb podcasts PODCAST_ID --order-by=duration
```

### Opening an episode

```bash
$ podrb open EPISODE_ID
$ podrb open EPISODE_ID --browser=firefox
$ podrb open EPISODE_ID --archive
```

### Archiving an episode

```bash
$ podrb archive EPISODE_ID
```

### Dearchiving an episode

```bash
$ podrb dearchive EPISODE_ID
```

### Synchronizing a podcast

```bash
$ podrb sync PODCAST_ID
```

### Updating the podcast

```bash
$ podrb update PODCAST_ID --feed=https://newfeed.com/feed.xml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gustavothecoder/podrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
