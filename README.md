# jekyll-pre-commit

A plugin to help make sure your post is _really_ ready for publishing.

## Installation

Add this line to your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem 'jekyll-migrate-permalink'
end
```

Then execute the `bundle` command to install the gem.

Next run `bundle exec jekyll pre-commit init` in the root of your Jekyll site. 

This will symlink this plugin's `pre-commit` file to the `.git/hooks/` directory of your project.

If you provide the `--force` flag when running `bundle exec jekyll pre-commit init` any existing `pre-commit` file will be deleted.

## Usage

Once installed you may choose the pre-commit checks you would like to use by listing them in your site's `_config.yml`.

```yaml
pre-commit:
  - DescriptionExists
  - DescriptionIsNotDuplicate
```

## Available Checks

#### DescriptionExists

This check ensures that there is a `description` in the front matter of any post that is staged to be committed.

#### DescriptionIsNotDuplicate

This check ensures that the `description` in the front matter of any post that is staged to be committed is unique amongst all the posts on your site.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpchadwick/jekyll-pre-commit.

Please ensure tests pass (using rspec) before submitting a pull request and provide test coverage for any new features.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

