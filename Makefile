# File:    Makefile
# Version: GNU Make 3.81
# Author:  Om Sharma (opsharma@noctr.edu)
# Purpose: Phony targets used for linting TeX and typesetting a PDF
#          for some quick testing.

# When "make" is run by itself, run the linter and build a PDF for local review
.DEFAULT_GOAL := all
.PHONY: all
all: lint pdf

# Add the date/time to the top of the log, then run the linter and
# write to stdout and to the log file
.PHONY: lint
lint:
	@echo "********** Starting  lint **********"
	@date > lint.log
	@chktex main.tex | tee -a lint.log
	@echo "********** Completed lint **********"

# Generate a detailed compilation report while not importing images (runs fast)
.PHONY: draft
draft:
	@echo "********** Starting  draft **********"
	@lualatex -shell-escape -jobname cv --interaction=nonstopmode --halt-on-error -draftmode main.tex
	@echo "********** Completed  draft **********"

# Run two passes of the lualatex compiler with minimal output
.PHONY: pass2
pass2:
	@echo "********** Starting  pass2 **********"
	@lualatex -shell-escape -jobname cv --interaction=batchmode --halt-on-error main.tex
	@lualatex -shell-escape -jobname cv --interaction=batchmode --halt-on-error main.tex
	@echo "********** Completed pass2 **********"

# After running the pass2 target, use the Mac-specific "open" command to
# view the PDF in whatever application is set as the default. Never use
# this target in a CI pipeline or the error "Couldn't get a file descriptor
# referring to the console" will get raised.
.PHONY: pdf
pdf: pass2
	@open cv.pdf

# Remove all temporary files. Note that removing the minted directory will
# significantly slow down compilation, so use sparingly
.PHONY: clean
clean:
	@rm -f lint.log cv.*
	@rm -rf _minted-cv/
