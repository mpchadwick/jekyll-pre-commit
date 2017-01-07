module Jekyll
  module PreCommit
    module Check
      class DescriptionIsGoodLength < Check
        def Check(staged, not_staged, site)
          staged.each do |post|
            if post.data["description"].length < 145
              @result[:ok] = false
              @result[:message] += post.data["title"] + "'s description is too short. "
            elsif post.data["description"].length > 165
              @result[:ok] = false
              @result[:message] += post.data["title"] + "'s description is too long. "
            end
          end

          @result
        end
      end
    end
  end
end
