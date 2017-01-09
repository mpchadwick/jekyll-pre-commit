module Jekyll
  module PreCommit
    module Check
      class FrontMatterPropertyIsNotDuplicate < Check
        def Check(staged, not_staged, site, args)
          if !args["properties"]
            @result[:message] += "No properties to check."
            return @result
          end

          existing = Hash.new
          not_staged.each do |post|
            args["properties"].each do |property|
              if !existing[property]
                existing[property] = Array.new
              end
              existing[property].push(post.data[property]) if post.data[property]
            end
          end

          staged.each do |post|
            args["properties"].each do |property|
              if existing[property].include? post.data[property]
                @result[:ok] = false
                @result[:message] += "#{post.data["title"]}'s #{property} was already used. "
              end
            end
          end

          @result
        end
      end
    end
  end
end
