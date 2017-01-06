module Jekyll
  module PreCommit
    autoload :VERSION, 'jekyll-pre-commit/version.rb'
  end
end


require 'jekyll-pre-commit/commands.rb'
