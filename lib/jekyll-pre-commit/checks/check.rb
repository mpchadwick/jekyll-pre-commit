module Jekyll
  module PreCommit
    module Check
      class Check
        def initialize
          @result = { :ok => true, :message => "" }
        end
      end
    end
  end
end
