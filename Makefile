CONFIG=book/book.yml
DESTINATION=builds
FLAGS=--safe-mode=secure --attribute=allow-uri-read
INPUT=builds/asciidoc/*.adoc
OUTPUT=$(DESTINATION)/recipe-book
TEMPERATURE_SYSTEM=imperial
ASCIIDOCTOR := bundle exec asciidoctor
ASCIIDOCTOR-PDF := bundle exec asciidoctor-pdf
DOCKER := $(shell command -v podman 2> /dev/null || echo docker) 
export PATH := bin:$(PATH)

.PHONY: all
all: asciidoc docbook html pdf epub

.PHONY: asciidoc
asciidoc:
	generate.py --configfile=$(CONFIG) --temperature=$(TEMPERATURE_SYSTEM) --builddir=$(DESTINATION)

.PHONY: docbook
docbook: asciidoc
	$(ASCIIDOCTOR) --backend=docbook $(FLAGS) $(INPUT) --destination-dir=$(DESTINATION)/docbook

.PHONY: pdf
pdf: asciidoc
	$(ASCIIDOCTOR-PDF) ${FLAGS} $(INPUT) --destination-dir=$(DESTINATION)/pdf

.PHONY: html
html:	asciidoc
	$(ASCIIDOCTOR) --backend=html5 $(FLAGS) $(INPUT) --destination-dir=$(DESTINATION)/html

.PHONY: epub
epub:	docbook
	mkdir -p builds/epub
	for file in `cd builds/docbook/ && find -name '*.xml'`; do \
	    echo pandoc --from docbook --to epub builds/docbook/$${file} -o builds/epub/$${file%.*}.epub ; \
	done

.PHONY: docker
docker:
	$(DOCKER) build --file openrecipebook.Dockerfile --squash --volume=$(PWD):/work:z --tag openrecipebook:latest

.PHONY: clean
clean:
	rm -rf $(DESTINATION):
	
