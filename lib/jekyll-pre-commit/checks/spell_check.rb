module Jekyll
  module PreCommit
    module Checks
      # This is a work-in-progress.
      class SpellCheck < Check
        def check(staged, not_staged, site, args)
          staged.each do |post|
            rendered = Jekyll::Renderer.new(site, post).run
            rendered.gsub!('"', '\"')
            mispells = `echo "#{rendered}" | sed "s/’/'/g" | aspell list -H --add-html-skip=pre --add-html-skip=code`
            puts mispells
          end
          exit 1
        end
      end
    end
  end
end
