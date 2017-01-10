module Jekyll
  module PreCommit
    autoload :VERSION, 'jekyll-pre-commit/version.rb'
  end
end

require 'jekyll-pre-commit/runner.rb'
require 'jekyll-pre-commit/commands.rb'
require 'jekyll-pre-commit/checks/check.rb'
require 'jekyll-pre-commit/checks/front_matter_variable_exists.rb'
require 'jekyll-pre-commit/checks/front_matter_variable_is_not_duplicate.rb'
require 'jekyll-pre-commit/checks/front_matter_variable_meets_length_requirements.rb'
