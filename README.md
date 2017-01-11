# jekyll-pre-commit

[![Gem Version](https://badge.fury.io/rb/jekyll-pre-commit.svg)](https://badge.fury.io/rb/jekyll-pre-commit)

A Jekyll plugin to make sure your post is _really_ ready for publishing.

![Terminal showing failed check](http://i.imgur.com/9PzDMiB.jpg)

## Installation

Add this line to your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem 'jekyll-pre-commit'
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
  - check: FrontMatterVariableExists
    variables: ['description', 'image']
  - check: FrontMatterVariableIsNotDuplicate
    variables: ['description']
  - check: FrontMatterVariableMeetsLengthRequirements
    variables: ['description', 'title']
```

## Available Checks

#### FrontMatterVariableExists

This check ensures that any listed variables exist in the front matter of any post that is staged to be committed.

#### FrontMatterVariableIsNotDuplicate

This check ensures that any listed variables are unique amongst all the posts on your site in the front matter of any post that is staged to be committed.

#### FrontMatterVariableMeetsLengthRequirements

This check ensures that any listed variables meet the length requirements (in number of characters) in the front matter of any post that is staged to be committed.

This check includes the following defaults:

**title**

- max: 59

**description**

- min: 145
- max: 165

These can be overridden, or requirements can be specified for other variables in the following format...

- `variable|min|max`

For example...

```yaml
- check: FrontMatterVariableMeetsLengthRequirements
  variables: ['title||50']
```

In the above, there would be a maximum length of 50 characters for the title (rather than the default of 59)

## Roll Your Own

You can also add your own checks. To do so, create a class in the `Jekyll::PreCommit::Checks` module and and define a `check` method. Your class should extend the `Jekyll::PreCommit::Checks::Check` class and return the `@result` instance variable. 

For example...

```ruby
module Jekyll
  module PreCommit
    module Checks
      class DoesNothing < Check
        def check(staged, not_staged, site, args)
          @result
        end
      end
    end
  end
end
```

Put this file in your plugins_path (which is _plugins by default) and `jekyll-pre-commit` will load it automatically. Then just specify that you'd like to run this check in your front matter.

```yaml
pre-commit:
  - check: DoesNothing
```

As you can probably tell by the name, this check doesn't actually do anything. Review the checks in `lib/jekyll-pre-commit/checks` for some more useful examples.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpchadwick/jekyll-pre-commit.

Please ensure tests pass (using rspec) before submitting a pull request and provide test coverage for any new features.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

