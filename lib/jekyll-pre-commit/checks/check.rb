module Jekyll
  module PreCommit
    module Checks
      class Check
        def initialize
          @result = { :ok => true, :message => "" }
        end
      end
    end
  end
end
