module Jekyll
  module PreCommit
    module Check
      class DescriptionExists < Check
        def Check(staged, not_staged, site)
          staged.each do |post|
            if !post.data["description"]
              @result[:ok] = false
              @result[:message] += post.data["title"] + " was missing a description. "
            end
          end

          @result
        end
      end
    end
  end
end
