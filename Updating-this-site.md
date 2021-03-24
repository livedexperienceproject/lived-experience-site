---
layout: page
title: Updating LEX
permalink: /documentation/
breadcrumb: true
header: false
gallery:
    - image_url: lex-community.jpg
      caption: Gallery example 1
    - image_url: lex-community.jpg
      caption: Gallery example 2
    - image_url: lex-community.jpg
      caption: Gallery example 3
exclude_from_search: true
---
{: #toc }
*  TOC
{:toc}

## Configuration

### Main menu navigation

Edit the main menu in `_data/navigation.yml`. Add a submenu to an item using the dropdown key.

    - title: About
      url: "/about/"
      side: left
      dropdown:
      - title: "About TerraLuna"
        url: "/about/terraluna"

### Homepage

Homepage 3-column widgets are edited in `pages/pages-root-folder/index.md` as frontmatter (widget1, 2, etc.)

### Page layouts

When creating a page or post you can define a page layout. This is set by default for pages and posts, so you only need to define it if you want to override the default.

Page layouts available:

- `layout: page` 8-column centered
- `layout: page-fullwidth` 12-column

### Footer info

The info in the footer:

- About blurb is in `_config.yml`
- Services are in `_data/services.yml`
- Social links are in `_data/socialmedia.yml`

### Sidebar

A sidebar can be enabled with `sidebar: right` or `sidebar: left`

If using a sidebar, the layout needs to be "page", as "page-fullwidth" will override the sidebar layout.

    ---
    layout: page
    sidebar: left
    ---

Content of the sidebar is edited in `_includes/sidebar.html`. It's static using HTML (not Markdown). I don't know how useful this will be.


- Other frontmatter
    - `breadcrumb: true` adds a navigation breadcrumb based on categories
    - `permalink: /path/to/page` to a post or page frontmatter defines its URL. Optional.
    - `author` should be set to the key name for an author listed in `_data/authors.yml`

            author: author-name
    - `header` can be `no` or have an array of settings. Most common:
        
            header:
                image_fullwidth: lex-shadows.jpg
                caption: Artwork by TK
                caption_url: https://www.odera.net/
    - `image:` can define an article image that appears before the headline. Must exist in `/images/`
    
            image:
                title: image_name.jpg

## Posts

Jekyll requires blog post files to be named according to the following format:

`YEAR-MONTH-DAY-title.md`

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit numbers. After that, include the necessary front matter. Take a look at the source for this post to get an idea about how it works. 

### Categories

Categories are set up to function like series. You can create a new category just by assigning it to one or more posts. The default category is "Blog". Posts with categories other than Blog are grouped together and can be viewed as a series by going to `[site URL]/category/category-name/` in the browser (`category-name` is simply the name of the category in lowercase with spaces replaced with dashes).

You can see all active categories by visiting `[site URL]/category`.

- Category names should be title cased
- Use array formatting in the frontmatter: `categories: ["Category One", "Blog"]`

### Tags

Add tags at your pleasure using the frontmatter for the post. Tags should be specified in array format, e.g. `tags: [tag 1, tag 2, other tag]`. Spaces are ok. You can also use the long form array syntax if it's easier:

    tags:
    - tag 1
    - tag 2
    - other tag

Tag indexes are automatically at `/topic/tag-name` and an index of all active tags is at `/topic/`. Clicking on a tag in the post metadata will show all other posts with that tag in reverse chronological order.

### Pull quotes

You can define a pullquote using the `pullquote` block tag. This tag has a beginning and end tag, and can be set to `left`, `right`, or `center` (defaults to center).

{% raw %}
    {% pullquote left %}Pull quote text goes here{% endpullquote %}
{% endraw %}

### Table of contents

To include a table of contents, include the following code in a post or page:

    {: #toc }
    *  TOC
    {:toc}

### Include a gallery. 

See the frontmatter of this post for a demo, then include `{% raw %}{% include gallery %}{% endraw %}` in the post.

{% include gallery %}

### Audio player

To include an audio file use `{% raw %}{% audio audio_file_name %}{% endraw %}` in the post/page. If an extension is specified, only that format will be linked. Otherwise it's assumed that you have multiple formats from mp3, wav, ogg, and oga available and any that exist in media/audio with the same base filename will be included in the tag's sources.

For example, if the tag is `{% raw %}{% audio sys078 %}{% endraw %}` and the `/media/audio/` directory contains `sys078.mp3` and `sys078.ogg`, then an HTML5 audio tag with sources for both formats will be created.

Using subdirectories is fine, in which case the tag would look like `{% raw %}{% audio subdir/file %}{% endraw %}`.

Add a title after the filename, and optionally include `download=true` to include a download link.

This:

{% raw %}
    {% audio sys078 Systematic Episode 78 download=true %}
{% endraw %}

Generates this:

{% audio sys078 Systematic Episode 78 download=true %}

### Images

In addition to the header image, a post image can be defined in the frontmatter like this:

    image:
        title: path/to/image.jpg

The path should be relative to `/images/`. An image defined in this manner will appear full-width above the headline and makes a good way to add a banner image to the post. This can be combined with `header: no` in the frontmatter to disable the standard banner image with logo. (Alternatively, you can always set a post image as the header image as well, see frontmatter section).

Having an image for the post defined makes display of the post in archive lists prettier. For consistency, if you're not specifying a main image, include `thumbnail: path_to_thumbnail` in the frontmatter, with a path to an image at least 450x450px. The image will be cropped for display, so the exact size and dimensions aren't important. It's prudent to keep the images as small as makes sense, though, for load times.

#### Including images within the post

The easiest way to include an image in the post with all appropriate markup is to use the `{% raw %}{% img %}{% endraw %}` tag. This takes a series of arguments, the simplest version being:

{% raw %}
    {% img path/to/image.jpg %}
{% endraw %}

Images are expected to be in the `/images/` directory, and can use relative paths to subdirectories from there. E.g. if you have an image in `/images/2020/07/myimage.png`, you can reference it with `{% raw %}{% img 2020/07/myimage.png %}{% endraw %}`

You can apply CSS classes to the image by preceding the filename with one or more class names:

{% raw %}
    {% img alignleft path/to/image.jpg %}
{% endraw %}

You can also specify a width and height after the image, which can help with lazy loading and page layout. This should be the natural size of the main (non-2x) image:

{% raw %}
    {% img path/to/image.jpg 800 600 %}
{% endraw %}

Alt text should always be included, and comes after any width or height:

{% raw %}
    {% img path/to/image.jpg 800 600 Alt Text for image %}
{% endraw %}

If you want a title as well (which creates a caption on the image), use two strings in quotes. The first one will become the title, the second the alt tag:

{% raw %}
    {% img path/to/image.jpg "This is the title" "image alt text" %}
{% endraw %}

A full tag would look like this:

{% raw %}
    {% img alignleft path/to/image.jpg 800 600 "The image title" "The Alt Text" %}
{% endraw %}

Use `{% raw %}{% imgd image... %}{% endraw %}` to define an image as the default image for the page, affecting social sharing. Otherwise `image:` in frontmatter is default.

#### A note on image sizes

Multiple sizes of an image can (and often should) be provided when using the `{% raw %}{% img %}{% endraw %}` tag. Preferably, a regular size image and a 2x size would be included, named with the same base: `myimage.png` and `myimage@2x.png`.

The base size for a 1x post banner image should be 970px wide, with an @2x version at 1940px.

Using the same base name, you can also add a size for mobile screens (which will also be used for the Twitter/Facebook thumbnail). To do so, add `_tw`, which in the previous example would give you a filename of `myimage_tw.png`. This image should be a 2:1 ratio at a minimum of 600px x 300px.

You can also specify a Facebook-only image with the suffix `_fb`. All of these suffixed images will be correctly extrapolated from the base img tag if they exist at the time of rendering.

If your main image is already at a 2:1 ratio or easily crops to that without losing content, you can skip the creation of `_tw` and `_fb` images, providing just the 1x and 2x versions.

### Contributor profiles

Contributors are edited in `_data/authors.yml`. The first entry in that file is commented to describe what each key does. The comments (lines starting with `#`) do not need to be copied when adding new authors.

Author photo: Photo should be specified as a relative path from `/images/`. Photo should be square (will be cropped to circle), at 300x300px.

Bio:  Note that a bio and summary can be included. The summary will appear at the end of a post attributed to that author, and the full bio will appear on the author page, along with a list of posts attributed to that author.

### Footnotes

Add footnotes in typical MultiMarkdown format: `[^identifier]` in the text, then define it on its own line:

    [^identifier]: This is the text for the footnote

It will insert a footnote like this[^fn1].

[^fn1]: This is a pretty cool footnote, if you ask me.

### Video

You can embed videos from YouTube and Vimeo with simple tags:

{% raw %}
    {% youtube VIDEO_ID %}
    {% vimeo VIDEO_ID %}
{% endraw %}

Grab the video ID from the url:

- https://www.youtube.com/watch?v=<mark>NwJl5w-h6Nc</mark>&feature=youtu.be
- https://vimeo.com/<mark>47494666</mark>

The videos will be embedded with a poster image and require a click to load. Ads/related videos will be disabled. The iframe will be responsive, adjusting its size to the width of the browser window/device. 

You can specify a width and height if the video is not a standard 16:9 format. Getting the dimensions right will help with scaling and presentation. The default values are 640 x 360. To get the natural size for a YouTube video, visit it in your browser and click on Share -> Embed. In the first line of the code that displays you'll see the width and height.

![YouTube Video Dimensions](http://assets.brettterpstra.com/dimensions-from-share.gif)

Add those to the tag:

{% raw %}
    {% youtube NwJl5w-h6Nc 560 315 %}
{% endraw %}

For Vimeo, basically the same process:

![Vimeo Video Dimensions](http://assets.brettterpstra.com/2020-08-06%2011.38.08.gif)

And added to the tag:

{% raw %}
    {% vimeo 47494666 640 360 %}
{% endraw %}

You can also provide a caption for a video by appending it to the end of the tag (regardless of whether dimensions are specified or not).

{% raw %}
    {% vimeo 47494666 "Decolonization Means Prison Abolition" %}
{% endraw %}

The above embeds this (resize the width of your viewport to see that it's fluid in size):

{% vimeo 47494666 "Decolonization Means Prison Abolition" %}

### Summary
{:data-summary="This is an example of a manually generated summary for this section."}

Summaries are automatically generated for pages with 3 or more headlines in the article context[^summary-headlines]. Summary text is pulled from the paragraphs immediately following each headline.

To manually define summary text, add a `data-summary` to the headline using Kramdown syntax:

    ### This is the headline
    {:data-summary="And this is a summary of the section."}



[^summary-headlines]: This can be adjusted in `assets/js/main.js` in the `tldr` call, 'minimumHeadlines' property.

### Post terminator

To include a terminator at the end of the last paragraph, use `...end of post.{% raw %}{% eof %}{% endraw %}`. If you don't leave a space between the last character and the tag, it will ensure that the last word breaks to a new line and doesn't leave the terminator hanging. This is recommended.{% eof %}

### DocumentCloud

Embed a DocumentCloud document or annotation using the `{% raw %}{% dc URL %}{% endraw %}` tag. The tag takes a URL pointing to either the document or a specific annotation. The easiest way to retrieve these URLs is to open the document in DocumentCloud and use the "Share" link in the sidebar. Choose the type of item to share, either "Share entire document," "Share specific page," or "Share specific note." Then select "Link" and copy the resulting URL.

Example (annotation):

{% raw %}
    {% dc https://beta.documentcloud.org/documents/20413901-screen-shot-2020-11-21-at-102719-am#document/p1/a2005512 %}
{% endraw %}

{% dc https://beta.documentcloud.org/documents/20413901-screen-shot-2020-11-21-at-102719-am#document/p1/a2005512 %}

Copying a DocumentCloud embed url:

![DocumentCloud Embed](http://assets.brettterpstra.com/documentcloudembed.gif "Copying a DocumentCloud embed URL")
