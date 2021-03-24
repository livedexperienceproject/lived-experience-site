# LEX

Lived Experience Project Website

## File Structure

- CSS is in /_sass
- Plugins in /_plugins
- Images should go in /images, ignore /assets/img
- Pages can all go in /pages. Subdirectories are optional, routing is determined by frontmatter

## Preview

Use Jekyll serve with livereload. Site will be available on localhost at http://127.0.0.1:4000/

@run(bundle exec jekyll serve --trace -l)

## Stage

Push to staging to initiate a build on Travis.ci. Settings for the build are in `.travis.yml`

## Deploy

A pull request to master has to be generated.

## Git

Development branch is `staging` and all commits should be made there. Do NOT commit to `master`.

