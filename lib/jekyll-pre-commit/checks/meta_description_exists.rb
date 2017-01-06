module Jekyll
  module PreCommit
    module Check
      class MetaDescriptionExists
        def Check(staged, site)
          staged.each do |post|
            if !post.data["description"]
              return false
            end
          end
          return true
        end
      end
    end
  end
end
