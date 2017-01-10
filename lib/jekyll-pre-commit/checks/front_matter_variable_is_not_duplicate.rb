module Jekyll
  module PreCommit
    module Check
      class FrontMatterVariableIsNotDuplicate < Check
        def check(staged, not_staged, site, args)
          if !args["variables"]
            @result[:message] += "No variables to check."
            return @result
          end

          existing = Hash.new
          not_staged.each do |post|
            args["variables"].each do |variable|
              if !existing[variable]
                existing[variable] = Array.new
              end
              existing[variable].push(post.data[variable]) if post.data[variable]
            end
          end

          staged.each do |post|
            args["variables"].each do |variable|
              if existing[variable].include? post.data[variable]
                @result[:ok] = false
                @result[:message] += "#{post.data["title"]}'s #{variable} was already used. "
              end
            end
          end

          @result
        end
      end
    end
  end
end
