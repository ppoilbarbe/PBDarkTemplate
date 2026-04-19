
BUILD_DIR     := build
BUILD_MOVIES  := PBDarkTemplateMovies
BUILD_TVSHOWS := PBDarkTemplateTVShows

MOVIE_FILES   := movies/* common/*
TVSHOW_FILES  := tvshows/* common/*

BOLD  := \033[1m
CYAN  := \033[1;36m
GREEN := \033[1;32m
RESET := \033[0m

# Download missing flag PNG files into a build directory.
# Language codes that differ from their ISO 3166-1 country code on flagcdn.com
# are handled by the case statement; all others use their own code as country code.
# Usage: $(call download_flags,<dir>)
define download_flags
	@langs=$$(sed -n '/^const translations/,/^\};/p' common/i18n.js \
	         | grep -oE '^    [a-z]+:' | tr -d ': '); \
	for lang in $$langs; do \
	    target=$(1)/flag_$${lang}.png; \
	    if [ ! -f "$$target" ]; then \
	        case $$lang in \
	            en) country=gb ;; \
	            zh) country=cn ;; \
	            vi) country=vn ;; \
	            *)  country=$$lang ;; \
	        esac; \
	        printf "$(CYAN)Downloading$(RESET) flag for %s...\n" "$$lang"; \
	        curl -sLo "$$target" "https://flagcdn.com/16x12/$${country}.png"; \
	    fi; \
	done
endef

.DEFAULT_GOAL := help
.PHONY: all movies tvshows clean flags help

all: movies tvshows

movies: build/$(BUILD_MOVIES).zip

tvshows: build/$(BUILD_TVSHOWS).zip

build/$(BUILD_MOVIES).zip: $(MOVIE_FILES)
	rm -rf $(BUILD_DIR)/$(BUILD_MOVIES)
	mkdir -p $(BUILD_DIR)/$(BUILD_MOVIES)
	cp movies/* $(BUILD_DIR)/$(BUILD_MOVIES)/
	cp common/* $(BUILD_DIR)/$(BUILD_MOVIES)/
	$(call download_flags,$(BUILD_DIR)/$(BUILD_MOVIES))
	cd $(BUILD_DIR) && zip -9r $(BUILD_MOVIES).zip $(BUILD_MOVIES)

build/$(BUILD_TVSHOWS).zip: $(TVSHOW_FILES)
	rm -rf $(BUILD_DIR)/$(BUILD_TVSHOWS)
	mkdir -p $(BUILD_DIR)/$(BUILD_TVSHOWS)
	cp tvshows/* $(BUILD_DIR)/$(BUILD_TVSHOWS)/
	cp common/* $(BUILD_DIR)/$(BUILD_TVSHOWS)/
	$(call download_flags,$(BUILD_DIR)/$(BUILD_TVSHOWS))
	cd $(BUILD_DIR) && zip -9r $(BUILD_TVSHOWS).zip $(BUILD_TVSHOWS)

clean:
	rm -rf $(BUILD_DIR)

flags:
	$(call download_flags,$(BUILD_DIR)/$(BUILD_MOVIES))
	$(call download_flags,$(BUILD_DIR)/$(BUILD_TVSHOWS))

help:
	@printf "$(BOLD)Targets:$(RESET)\n"
	@printf "  $(CYAN)make$(RESET)         Show this help\n"
	@printf "  $(CYAN)make all$(RESET)     Build both templates\n"
	@printf "  $(CYAN)make movies$(RESET)  Build the movies template\n"
	@printf "  $(CYAN)make tvshows$(RESET) Build the TV shows template\n"
	@printf "  $(CYAN)make clean$(RESET)   Remove the build directory\n"
	@printf "  $(CYAN)make flags$(RESET)   Download missing flag images into build directories\n"
	@printf "\n"
	@printf "$(BOLD)Platforms:$(RESET)\n"
	@printf "  $(GREEN)Linux$(RESET)    make (native)\n"
	@printf "  $(GREEN)macOS$(RESET)    make (requires Xcode Command Line Tools)\n"
	@printf "  $(GREEN)Windows$(RESET)  make inside WSL (Windows Subsystem for Linux)\n"
