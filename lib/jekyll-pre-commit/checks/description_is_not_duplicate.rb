module Jekyll
  module PreCommit
    module Check
      class DescriptionIsNotDuplicate < Check
        def Check(staged, not_staged, site, args)
          existing = Array.new
          not_staged.each do |post|
            if post.data["description"]
              existing.push(post.data["description"])
            end
          end

          staged.each do |post|
            if (existing.include? post.data["description"])
              @result[:ok] = false
              @result[:message] += post.data["title"] + "'s description was already used. "
            end
          end

          @result
        end
      end
    end
  end
end
