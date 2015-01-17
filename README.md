scotchit
========

Statistical analysis of [reddit.com/r/scotch](http://www.reddit.com/r/Scotch/) Scotch ratings.

You may want to obtain a new copy of the spreadsheet from the sidebar at [reddit.com/r/scotch](http://www.reddit.com/r/Scotch/).

I use this as a survey of Scotchit's ratings to make recommendations on scotch to try.

Here's an example output:

* Glenfarclas 40: 69% (11+, 11#) $$$$$
* Laphroaig Càirdeas Portwood: 67% (25+, 29#) $$$
* Ardbeg Uigeadail: 62% (73+, 100#) $$$
* Aberlour A'bunadh batch #36: 61% (8+, 8#) $$
* Benrinnes 23: 58% (7+, 7#) $$$$$
* Benrinnes 14 AD Rattray Sherry Cask: 54% (6+, 6#) $$$$
* Macallan Sherry Cask Strength: 51% (39+, 60#) $$$
* Lagavulin 12: 50% (23+, 33#) $$$$

=======
Where the first number is a confidence score expressed as a whole percentage followed by (positive votes, sample size) and a price indicator.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scotchit'
```

And then execute:

$ bundle

Or install it yourself as:

$ gem install scotchit

## Usage

`./bin/scotchit`

## Contributing

1. Fork it ( https://github.com/rhardin/scotchit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
