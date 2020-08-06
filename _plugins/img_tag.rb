# Title: Image tag for Jekyll
# Author: Brett Terpstra
# Description: Easily output images with optional class names, width, height, title and alt attributes
#
# Additions: REVAMPED to use loading="lazy"
#            insert @2x data attribute - this uses an htaccess rule that serves the
#              1x if no @2x version exists.
#
#              if tag is {% imgd %}, set as default image for social sharing
#
#              # Image handling for retina
#              RewriteCond %{REQUEST_FILENAME} !-f
#              RewriteRule (.*)@2x\.(jpg|png|gif) $1.$2 [L]
#            if imgd is used, make the image the default for the page
#            (OpenGraph settings), {% imgd /path/ %}
#
# Syntax {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] ["title text"] ["alt text"] %}
#
# Examples:
# {% img /images/ninja.png Ninja Attack! %}
# {% img left half http://site.com/images/ninja.png Ninja Attack! %}
# {% img left half http://site.com/images/ninja.png 150 150 "Ninja Attack!" "Ninja in attack posture" %}

module Jekyll
  # {% img %} tag
  class ImageTag < Liquid::Tag
    @img = {}
    @is_default = false

    def initialize(tag_name, markup, tokens)
      # <img class="lazy" src="img/grey.gif" data-original="img/example.jpg" width="640" height="480">
      if markup =~ /^\s*((?:\S+ )*)((?:https?:\/\/|\/|\S+\/)?\S+(?:\.(?:png|jpe?g|gif)))(?:\s+(\d+))?(?:\s+(\d+))?\s+(.*)?/i
        m = Regexp.last_match
        unless m[2].nil?
          imgclass = m[1] || nil
          image = m[2]
          width = m[3] || nil
          height = m[4] || nil
          title = m[5] || nil
          @img = {}
          @img['class'] = imgclass ? imgclass.strip : ''
          @img['loading'] = 'lazy'
          @img['src'] = image
          @img['width'] = width if width
          @img['height'] = height if height
          if title && title !~ /^[\s"]*$/
            if /(?:"|')(?<xtitle>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ title
              @img['title']  = xtitle
              @img['alt']    = alt
            else
              @img['alt']    = title.gsub(/(^["\s]*|["\s]*$)/, '')
            end
          end
        end
        if tag_name.strip == 'imgd'
          @is_default = true
        end
      end
      super
    end

    def add_suffix(src, suffix)
      src.sub(/\.(png|jpe?g|gif)$/, "_#{suffix}.\\1")
    end

    def suffix_exist?(src, suffix)
      base = File.join('.', src)
      File.exist? add_suffix(base, suffix)
    end


    def render(context)
      if @img && !@img.empty?
        imgurl = context.registers[:site].config['urlimg']
        @img['src'] = File.join(imgurl, @img['src'])
        @img['data-original'] = @img['src'].dup
        @img['data-at2x'] = @img['src'] =~ /@2x\./ ? @img['src'].dup : @img['src'].sub(/\.(png|jpe?g|gif)$/, '@2x.\1')

        if @is_default && context.environments.first['page']['image'].nil?
          ogimg = @img['src'].dup
          fbimg = @img['src'].dup
          ogimg = add_suffix(ogimg, 'tw') if suffix_exist?(ogimg, 'tw')
          fbimg = add_suffix(fbimg, 'fb') if suffix_exist?(fbimg, 'fb')
          context.environments.first['page']['ogimage'] = ogimg
          context.environments.first['page']['fbimage'] = fbimg
        end

        orig = @img['src']
        small_img = suffix_exist?(orig, 'tw') ? add_suffix(orig, 'tw') : orig

        if @img.key?('title')
          figclass = @img['class'].sub(/lazy\s*/, '')
          @img['class'] = nil
          # %(<figure class="#{figclass}"><img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>
          # <figcaption>#{@img['title']}</figcaption></figure>)

          %(<figure class="#{figclass}">
              <picture>
                  <source media="(max-width: 640px)" srcset="#{small_img}" />
                  <source srcset="#{@img['data-original']} 1x, #{@img['data-at2x']} 2x" />
                  <img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")} />
              </picture>
              <figcaption>#{@img['title']}</figcaption>
            </figure>)
        else
          @img['title'] = @img['alt']
          %(<picture>
                <source
                    media="(max-width: 640px)"
                    srcset="#{small_img}"
                  />
                <source srcset="#{@img['data-original']} 1x, #{@img['data-at2x']} 2x" />
                <img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")} />
            </picture>)
          # %Q{<img #{@img.collect {|k,v| "#{k}=\"#{v}\"" if v}.join(" ")}>}
        end
      else
        %(Error processing input, expected syntax: {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [alt text | "title text" "alt text"] %})
      end
    end
  end
end

Liquid::Template.register_tag('img', Jekyll::ImageTag)
Liquid::Template.register_tag('imgd', Jekyll::ImageTag)
