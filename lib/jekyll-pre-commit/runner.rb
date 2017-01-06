module Jekyll
  module PreCommit
    class Runner

      def run(site, staged_files)
        messages = Array.new
        staged_posts = Array.new
        site.posts.docs.each do |p|
          if (staged_files.include? p.path.gsub(Dir.pwd + "/", ""))
            staged_posts.push(p)
          end
        end
        if staged_posts.empty?
          # If no posts are being committed. Safe to commit.
          return messages
        end

        site.config["pre-commit"].each do |c|
          o = Object.const_get("Jekyll::PreCommit::Check::" + c).new
          result = o.Check(staged_posts, site)
          if !result[:ok]
            messages.push(result[:message])
          end
        end

        return messages
      end
    end
  end
end
