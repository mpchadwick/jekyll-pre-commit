module Jekyll
  module Commands
    class PreCommit < Command
      class << self
        def init_with_program(prog)
          prog.command(:"pre-commit") do |c|
            c.syntax 'pre-commit SUBCOMMAND'
            c.description 'Runs SUBCOMMAND'
            c.option "force", "--force", "Overwrites an existing pre-commit if one already exists"

            c.action do |args, options|
              raise ArgumentError, "You must provide a subcommand" if args.empty?
              if args.include? "init"
                dest = "#{Dir.pwd}/.git/hooks/pre-commit"
                if (File.exist?(dest) && !options["force"])
                  Jekyll.logger.abort_with "An existing pre-commit file already exists. If you'd like" \
                    " to overwrite that file (e.g. you're upgrading) pass the --force flag."
                end

                if (File.exist?(dest))
                  File.delete(dest)
                end

                # Is there a better way to resolve this path?
                src = `bundle show jekyll-pre-commit`
                src = src.strip + "/lib/jekyll-pre-commit/pre-commit"

                File.symlink src, dest
                puts "pre-commit hook file created!"
              end
            end
          end
        end
      end
    end
  end
end
