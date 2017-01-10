module Jekyll
  module PreCommit
    module Checks
      class FrontMatterVariableMeetsLengthRequirements < Check

        DEFAULT_LENGTH_REQUIREMENTS = {
          "description" => {
            "min" => 145,
            "max" => 165,
          },
          "title" => {
            "max" => 59
          }
        }

        def check(staged, not_staged, site, args)
          if !args["variables"]
            @result[:message] += "No variables to check."
            return @result
          end

          staged.each do |post|
            args["variables"].each do |variable|
              parts = variable.split('|')
              next if !post.data[parts[0]]
              # If use custom configuration if provided
              if parts[1]
                min = parts[1].to_i
                max = parts[2].to_i
              else
                if DEFAULT_LENGTH_REQUIREMENTS[variable] && DEFAULT_LENGTH_REQUIREMENTS[variable]["min"]
                  min = DEFAULT_LENGTH_REQUIREMENTS[variable]["min"]
                end
                if DEFAULT_LENGTH_REQUIREMENTS[variable] && DEFAULT_LENGTH_REQUIREMENTS[variable]["max"]
                  max = DEFAULT_LENGTH_REQUIREMENTS[variable]["max"]
                end
              end

              if min && post.data[parts[0]].length < min
                @result[:ok] = false
                @result[:message] += "#{post.data["title"]}'s #{parts[0]} is too short. "
              elsif max && post.data[parts[0]].length > max
                @result[:ok] = false
                @result[:message] += "#{post.data["title"]}'s #{parts[0]} is too long. "
              end
            end
          end

          @result
        end
      end
    end
  end
end
