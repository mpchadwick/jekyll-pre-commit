module Jekyll
  module PreCommit
    module Checks
      class NoTodos < Check
        def check(staged, not_staged, site, args)
          staged.each do |post|
            if post.to_s.downcase.include? 'todo'
              @result[:ok] = false
              @result[:message] += "A todo was found in #{post.data["title"]}. "
            end
          end

          @result
        end
      end
    end
  end
end
