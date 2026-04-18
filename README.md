# PB Dark Template

## Description

These templates are forks from Dark Template (don't know source,
marked as from https://buron.coffee/files/darkTemplate which does not
exist, while https://buron.coffee still exists).

There is two templates:

- PBDarkTemplateMovies: a template for movies
- PBDarkTemplateTVShows: a template for... TV shows

They are based on Dark Template with many enhancements:

- Both can be exported in the same directory without filename clash
- There is a main index file to switch from movies to TV shows and back

There is some modifications on visuals: added video format and main audio codec.

To date, they are translated info French.

## Building

Use the script "build.sh" to build both templates or type the command
"make" (Linux).

This will create a "build" directory which will contain both templates
and zip files.

Dependencies (Linux):

- Linux (or WSL under windows)
- zip (to create the compressed files)
- make (to build with make, optional)

## Installing

Once built, you can (choose one method):

- copy the built directories in the "templates" directory of tinyMediaManager
- unzip the zip files in the "templates" directory of tinyMediaManager

## TO DO

- Allow to automatically translate into the browser preferred language
  and fallback to english if it is not one of the known languages.
