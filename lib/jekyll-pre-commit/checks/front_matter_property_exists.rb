module Jekyll
  module PreCommit
    module Check
      class FrontMatterPropertyExists < Check
        def Check(staged, not_staged, site, args)
          if !args["properties"]
            @result[:message] += "No properties to check."
            return @result
          end

          staged.each do |post|
            args["properties"].each do |property|
              if !post.data[property]
                @result[:ok] = false
                @result[:message] += "#{post.data["title"]} was missing a #{property}. "
              end
            end
          end

          @result
        end
      end
    end
  end
end
