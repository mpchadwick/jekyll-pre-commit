module Jekyll
  module PreCommit
    module Check
      class DescriptionExists
        def Check(staged, not_staged, site)
          result = { :ok => true, :message => "" }
          staged.each do |post|
            if !post.data["description"]
              result[:ok] = false
              result[:message] += post.data["title"] + " was missing a description. "
            end
          end
          return result
        end
      end
    end
  end
end
