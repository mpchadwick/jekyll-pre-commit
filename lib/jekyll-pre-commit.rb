module Jekyll
  module PreCommit
    autoload :VERSION, 'jekyll-pre-commit/version.rb'
  end
end

require 'jekyll-pre-commit/runner.rb'
require 'jekyll-pre-commit/commands.rb'
require 'jekyll-pre-commit/checks/description_exists.rb'
require 'jekyll-pre-commit/checks/description_is_not_duplicate.rb'
require 'jekyll-pre-commit/checks/description_is_good_length.rb'
