class Tumblr
  class Post
    
    def self.process_options(*args)
      options = {}
      if args.last.is_a?(Hash)
        options.merge(args.pop)
      elsif args.last.is_a?(String) and File.file? args.last
        doc = IO.read(args.pop)
        if doc =~ /^(\s*---(.*)---\s*)/m
          options = YAML.load(Regexp.last_match[2].strip)
          options[:body] = doc.sub(Regexp.last_match[1],'').strip
        end
      end
      if((user = args.first).is_a?(Tumblr::User))
        options = options.merge(
          :email => user.email,
          :password => user.password
        )
      end
      if(options[:post_id])
        options['post-id'] = options[:post_id]
        options[:post_id] = nil
      end
      return options
    end
  
 end
end
