module Jekyll
  module PreCommit
    class Runner

      def run(site, staged_files)
        result = { :ok => true, :messages => [] }
        if !site.config["pre-commit"] || site.config["pre-commit"].empty?
          # Bail if there are no pre-commit checks enabled
          result[:messages].push("No pre-commit checks enabled")
          return result
        end

        staged_posts = Array.new
        not_staged_posts = Array.new

        site.posts.docs.each do |p|
          if (staged_files.include? p.path.gsub(Dir.pwd + "/", ""))
            staged_posts.push(p)
          else
            not_staged_posts.push(p)
          end
        end

        if staged_posts.empty?
          # If no posts are being committed. Safe to commit.
          result[:messages].push("No posts staged")
          return result
        end

        site.config["pre-commit"].each do |c|
          begin
            o = Object.const_get("Jekyll::PreCommit::Check::" + c["check"]).new
          rescue
            result[:ok] = false
            # Skip any other messages so the user focuses on this.
            result[:message] = ["The check #{c["check"]} does not exist! Please fix your configuration."]
            break
          end
          r = o.Check(staged_posts, not_staged_posts, site, c)
          if !r[:ok]
            result[:ok] = false
          end
          if r[:message] != ""
            result[:messages].push(r[:message])
          end
        end

        return result
      end
    end
  end
end
