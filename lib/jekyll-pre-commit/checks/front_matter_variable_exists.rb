module Jekyll
  module PreCommit
    module Check
      class FrontMatterVariableExists < Check
        def check(staged, not_staged, site, args)
          if !args["variables"]
            @result[:message] += "No variables to check."
            return @result
          end

          staged.each do |post|
            args["variables"].each do |variable|
              if !post.data[variable]
                @result[:ok] = false
                @result[:message] += "#{post.data["title"]} was missing a #{variable}. "
              end
            end
          end

          @result
        end
      end
    end
  end
end
