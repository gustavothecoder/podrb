# Pod

Simple CLI to manage podcasts.

## Installation

Pod is a Ruby gem published on RubyGems, so you can install running:

```bash
$ gem install pod
```

## Usage

### Initialization

```bash
$ pod init
```

### Adding a podcast

```bash
$ pod add ./path/to/rss.xml
$ pod add https://podcast.com/feed.xml
```

### Listing podcasts

```bash
$ pod podcasts
$ pod podcasts --fields=id name
```

### Listing episodes

```bash
$ pod episodes PODCAST_ID
$ pod podcasts PODCAST_ID --fields=id title duration
$ pod podcasts PODCAST_ID --order-by=duration
```

### Opening an episode

```bash
$ pod open EPISODE_ID
$ pod open EPISODE_ID --browser=firefox
$ pod open EPISODE_ID --archive
```

### Archiving an episode

```bash
$ pod archive EPISODE_ID
```

### Dearchiving an episode

```bash
$ pod dearchive EPISODE_ID
```

### Synchronizing a podcast

```bash
$ pod sync PODCAST_ID
```

### Updating the podcast

```bash
$ pod update PODCAST_ID --feed=https://newfeed.com/feed.xml
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gustavothecoder/pod.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
