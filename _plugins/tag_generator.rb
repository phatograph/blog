module Jekyll

  class TagIndex < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      tag_title_prefix = site.config['tag_title_prefix'] || ''
      tag_title_suffix = site.config['tag_title_suffix'] || ''
      self.data['title'] = "#{tag_title_prefix}#{tag}#{tag_title_suffix}"
    end
  end

  class TagGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || 'tag'
        site.tags.keys.each do |tag|
          write_tag_index(site, File.join(dir, tag.gsub(/\s+/, '-').downcase), tag)
        end
      end
    end

    def write_tag_index(site, dir, tag)
      index = TagIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end

  # Adds some extra filters used during the tag creation process.
  module Filters

    # Outputs a list of tags as comma-separated <a> links. This is used
    # to output the tag list for each post on a tag page.
    #
    #  +tags+ is the list of tags to format.
    #
    # Returns string
    #
    def tag_links(tags)
      tags = tags.sort!.map { |c| tag_link c }

      case tags.length
      when 0
        ""
      when 1
        tags[0].to_s
      else
        "#{tags[0...-1].join(', ')}, #{tags[-1]}"
      end
    end

    # Outputs a single tag as an <a> link.
    #
    #  +tag+ is a tag string to format as an <a> link
    #
    # Returns string
    #
    def tag_link(tag)
      "<a class='tag' href='/tag/#{tag.gsub(/\s+/, '-').downcase}/'>#{tag}</a>"
    end

    def gh_history_link(id)
      id = id.gsub(/\/post\//, '').gsub('/', '-')
      "https://github.com/phatograph/blog/commits/master/_posts/#{id}.markdown"
    end
  end

end
