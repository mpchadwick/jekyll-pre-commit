module Jekyll
  module PreCommit
    autoload :VERSION, 'jekyll-pre-commit/version.rb'
  end
end

require 'jekyll-pre-commit/runner.rb'
require 'jekyll-pre-commit/commands.rb'
require 'jekyll-pre-commit/checks/meta_description_exists.rb'
