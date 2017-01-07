module Jekyll
  module PreCommit
    module Check
      class DescriptionIsNotDuplicate
        def Check(staged, not_staged, site)
          result = { :ok => true, :message => "" }

          existing = Array.new
          not_staged.each do |post|
            if post.data["description"]
              existing.push(post.data["description"])
            end
          end

          staged.each do |post|
            if (existing.include? post.data["description"])
              result[:ok] = false
              result[:message] += post.data["title"] + "'s description was already used. "
            end
          end
          return result
        end
      end
    end
  end
end
