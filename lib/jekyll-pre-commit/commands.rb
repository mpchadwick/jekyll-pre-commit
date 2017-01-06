module Jekyll
  module Commands
    class PreCommit < Command
      class << self
        def init_with_program(prog)
          prog.command(:precommit) do |c|
            c.syntax 'hello'
            c.description 'Says hello'

            c.action do |args, options|
              Jekyll.logger.info "Precommit"
            end
          end
        end
      end
    end
  end
end
