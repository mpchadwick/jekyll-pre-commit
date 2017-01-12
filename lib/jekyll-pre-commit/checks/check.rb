module Jekyll
  module PreCommit
    module Checks
      # The baseline check class
      # All checks should extend this class
      class Check
        def initialize
          @result = { ok: true, message: '' }
        end
      end
    end
  end
end
