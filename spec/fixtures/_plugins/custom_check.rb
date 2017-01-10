module Jekyll
  module PreCommit
    module Check
      class CustomCheck < Check
        def check(staged, not_staged, site, args)
          @result[:message] += "I was created."
          @result
        end
      end
    end
  end
end
