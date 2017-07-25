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
                  normalized[n] = Hash.new
                  normalized[n]["path"] = post.relative_path
                  normalized[n]["tag"] = tag
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
                  @result[:message] += "The tag '#{tag}' appears to be duplicated and is listed as '#{normalized[n]["tag"]}' in #{normalized[n]["path"]}. "
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
