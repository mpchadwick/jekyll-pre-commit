module Jekyll
  module PreCommit
    module Checks
      class NoDuplicateTags < Check
        def check(staged, not_staged, site, args)
          raw = Hash.new
          normalized = Hash.new
          not_staged.each do |post|
            if post.data["tags"].size > 0
              post.data["tags"].each do |tag|
                if !raw[tag]
                  raw[tag] = post.relative_path
                end

                n = Jekyll::Utils.slugify(tag)
                if !normalized[n]
                  normalized[n] = post.relative_path
                end
              end
            end
          end

          staged.each do |post|
            if post.data["tags"].size > 0
              post.data["tags"].each do |tag|
                n = Jekyll::Utils.slugify(tag)

                if normalized[n] && !raw[tag]
                  @result[:ok] = false
                  @result[:message] += "#{tag} appears to be duplicated in #{normalized[n]}!"
                end
              end
            end
          end

          @result
        end
      end
    end
  end
end
