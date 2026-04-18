
MOVIE_FILES := movies/* common/*
TVSHOW_FILES := tvshows/* common/*

all: build/PBDarkTemplateMovies.zip build/PBDarkTemplateTVShows.zip
clean:
	./build.sh clean

build/PBDarkTemplateMovies.zip: $(MOVIE_FILES)
	./build.sh movies

build/PBDarkTemplateTVShows.zip: $(TVSHOW_FILES)
	./build.sh tvshows
