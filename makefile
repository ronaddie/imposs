.SUFFIXES : .dvi .tex .bbl .ind .aux .oldaux .html .ps .m .eps .pdf .bsh .c .pl .java .class .glo .gls .idx .glo .gls .dia .xml .Snw .qb
# PRESERVE the following lines when applying newpaper
TEX1FILES = imposs.tex
TEX2FILES = 
TEXFILES = $(TEX1FILES) $(TEX2FILES)
BIBFILES = imposs.bib
BBLFILES = imposs.bbl
SRCFILES = $(TEXFILES) makefile $(BIBFILES) $(BBLFILES)
TEMPLATEDIR = ${templatesdir}
BINDIR = ${HOME}/bin
DOCFILES = README
GRAPHICSFILES =
TGZFILES = $(SRCFILES) $(GRAPHICSFILES) $(BIBFILES)
EXPORTFILES = $(TEXFILES) $(BBLFILES) $(DOCFILES) $(BIBFILES) imposs
EXPORTFILES2 = imposs.tgz
MINIEXPORTFILES = imposs.pdf imposs.html imposs
GENERATEDFILES = imposs.log imposs.ps imposs.aux \
                 imposs.pdf imposs.tgz \
                 imposs.minitgz makefile.new imposs.blg \
                 imposs.bbl imposs.tex~ imposs.oldaux \
                 makefilehelp ftpcmds makefile.template .CODE
BINFILES =
TEMPLATEFILES =
ZIPFILES = imposs.tex
ZIPBFILES = imposs.pdf
STYLEFILES = 
EXPORTHOST = probus
EXPORTDIR = impossible
EXPORTSITE = $(EXPORTHOST):$(EXPORTDIR)
EXPORTDIR2 = impossible/courseteam
EXPORTSITE2 = $(EXPORTHOST):$(EXPORTDIR2)
REEXPORTHOST = probus
REEXPORTDIR = impossible
REEXPORTSITE = $(REEXPORTHOST):$(REEXPORTDIR)
MINIEXPORTDIR = impossible
MINIEXPORTSITE = $(EXPORTHOST):$(MINIEXPORTDIR)
EXPORTCMD = rsync -a -L -e ssh
REEXPORTCMD = scp -r
# POSTEXPORTCMD = ssh $(EXPORTHOST) "cd $(EXPORTDIR) ; make reexport"
POSTEXPORTCMD = 
INSTALLCMD = cp
MKFRAMES = mkframes3.pl -p ~/units/64428/sguide/toctop.html -q ~/units/64428/sguide/tocbot.html -P "</font><p><font size=-1>" -l -r -h 0 -b
BINDIR = $(HOME)/bin
TEMPLATEDIR = $(templatesdir)
# LATEX2HTMLCMD = "tth -p~/tthinputs -L$*"
LATEX2HTMLCMD = latex2html -show_section_numbers -split 3 -toc_stars -toc_depth 4 -link 4 -t TOP
ICONDIR = /usr/local/src/latex2html/icons.gif
ICONFILES =  blueball.gif change_begin.gif change_begin_right.gif \
change_delete.gif change_delete_right.gif change_end.gif change_end_right.gif \
contents.xbm contents_motif.gif cross_ref_motif.gif foot_motif.gif \
greenball.gif icons.html image.gif index_motif.gif invis_anchor.xbm \
lucy_left.gif lucy_left_gr.gif lucy_right.gif lucy_right_gr.gif \
lucy_up.gif lucy_up_gr.gif next_group_motif.gif next_group_motif_gr.gif \
next_motif.gif next_motif_gr.gif orangeball.gif pinkball.gif \
previous_group_motif.gif previous_group_motif_gr.gif  previous_motif.gif \
previous_motif_gr.gif purpleball.gif redball.gif up_motif.gif \
up_motif_gr.gif whiteball.gif yellowball.gif
ICONDIR = /usr/local/src/latex2html/icons.gif
all: imposs.pdf  
# UPDATE the following lines when running newpaper
allpdfs:
	for f in *.eps ; \
	do make `echo $$f | sed 's/eps/pdf/'` ; \
	done
clean:
	rm -rf $(GENERATEDFILES)
	rm *.aux *ans* *old* *.ind *.inx *.out
update:
	cvs update
release:
	cd $parentdir ;\
	cvs release -d $dir
commit:
	cvs commit
help:
	less makefilehelp
print: imposs.ps 
	lpr imposs.ps
mpage: imposs.ps
	mpage -1 -o -t -P -dp -m0 imposs.ps
xview: imposs.pdf
	evince imposs.pdf &
xviewans: imposs_ans.pdf
	evince imposs_ans.pdf &
view: imposs.pdf
	evince imposs.pdf &
imposs_ans.tex: imposs.tex
	sed -e 's/ansfalse/anstrue/g' < imposs.tex > imposs_ans.tex 
imposs.ps: imposs.pdf
imposs.html: imposs.aux $(TEX1FILES) imposs.bbl .latex2html-init
imposs.bbl: $(TEX1FILES) $(BIBFILES)
imposs.pdf: $(TEX1FILES) $(BIBFILES) $(GRAPHICSFILES) imposs.aux imposs.ind
imposs.tgz: $(TGZFILES)
	tar -czvf imposs.tgz $(TGZFILES)  
imposs.minitgz: $(SRCFILES)
	tar -czvf imposs.minitgz $(SRCFILES) 
imposs.zip: $(ZIPFILES)  $(ZIPBFILES)
	if [ -f imposs.zip ] ; then \rm imposs.zip ; fi
	zip -l imposs.zip $(ZIPFILES) 
	zip imposs.zip $(ZIPBFILES)
reexport: $(EXPORTFILES)  
	ssh $(REEXPORTHOST) "bash -c \"if [ -d $(REEXPORTDIR) ] ; then echo 'Directory exists' ; else mkdir -p $(REEXPORTDIR) ; fi\""
	$(REEXPORTCMD) index.tgz $(EXPORTFILES) makefile $(REEXPORTSITE)
export: $(EXPORTFILES) imposs.ps  \
        imposs.pdf  imposs.html 
	ssh $(EXPORTHOST) "bash -c \"if [ -d $(EXPORTDIR) ] ; then echo 'Directory exists' ; else mkdir -p $(EXPORTDIR) ; fi\""
	$(EXPORTCMD) imposs.tgz $(EXPORTFILES) imposs.pdf makefile \
              imposs.html $(EXPORTSITE)
	$(POSTEXPORTCMD) 
miniexport: $(MINIEXPORTFILES)
	ssh $(EXPORTHOST) "bash -c \"if [ -d $(MINIEXPORTDIR) ] ; then echo 'Directory exists' ; else mkdir -p $(MINIEXPORTDIR) ; fi\""
	$(EXPORTCMD) $(MINIEXPORTFILES) $(MINIEXPORTSITE)
	$(POSTEXPORTCMD) 
install:
	$(INSTALLCMD) $(BINFILES) $(BINDIR)
	$(INSTALLCMD) $(TEMPLATEFILES) $(STYLEFILES) $(TEMPLATEDIR)
.m.eps:
	matlab -display 0 < $< 
.m.pcm: 
	vis -uo < $< > $@
.aux.oldaux:
	latex $*
	chkdiff $*
.pdf.ps:
	pdftops $*.pdf
.tex.ps: $< $*.aux
	pdflatex $<
	if ! chkdiff $* ; then pdflatex $< ; fi
	if ! chkdiff $* ; then pdflatex $< ; fi
	chkdiff $*
	pdftops $*.pdf
.tex.dvi: $< $*.aux
	chngpdftex.pl $< $*.XXDVIXX
	cp $< $*.XXSAVEPDFXX
	mv $*.XXDVIXX $<
	latex $<
	chkdiff $*
	mv $*.XXSAVEPDFXX $<
.idx.ind:
	makeindex < $< > $@
.aux.bbl:
	if grep "^\\\\bibliography" $*.tex ; then bibtex $* ; fi
.tex.html:
	$(LATEX2HTMLCMD) $*
	( cd $* ; rm -f $(GRAPHICSFILES) )
	for f in $(GRAPHICSFILES) ; \
	do ln -s /home/addie/usq/pg/PhD/Kaled/mypapers/impossible/$$f $*/$$f ; \
	done
	if [ ! "$(ICONFILES)" = "" ] ; \
	then ( cd $* ; rm -f $(ICONFILES) ) ; \
	( cd $(ICONDIR) ; cp $(ICONFILES) /home/addie/usq/pg/PhD/Kaled/mypapers/impossible/$* );\
	fi
	touch $*.html
	cd $* ;\
	replace "< Objectives" "Objectives" $*.html index.html ;\
	$(MKFRAMES) ;\
	if [ -f node1.html ] ;\
	then replace "< Objectives" "Objectives" node*.html ;\
	fi
.xml.tex: $<
	mkgoodsb -f $<
	for f in /home/addie/good/tmp/stage3.tex ; \
		do eval `echo "cp $$f $$f" | sed 's/\/home\/addie\/good\/tmp\//GOOD/' | sed "s/\/home\/addie\/good\/tmp\/stage3/$*/" | sed 's/GOOD/\/home\/addie\/good\/tmp\//'` ; \
		done ; \
	overwrite $*.tex /usr/bin/perl -n -e '$$_ =~ s/\\Img{(.*)\.eps}/\\Img{$$1.pdf}/;' -e 'print;' < $*.tex
.tex.pdf: $< $*.aux
	pdflatex $<
	if ! chkdiff $* ; then pdflatex $< ; fi
	if ! chkdiff $* ; then pdflatex $< ; fi
	chkdiff $*
.tex.bsh: $<
	tex2bash $*
.tex.pl: $<
	tex2bash $*.tex $*.pl
.eps.pdf: $<
	epstopdf $<
.tex.aux:
	touch $*.aux
.tex.oldaux:
	touch $*.oldaux
.tex.idx:
	touch $*.idx
.dia.eps:
	dia -e $*.eps $<
.Snw.tex: $<
	Rscript -e "Sweave(\"$<\")"
.qb.tex: $<
	quickbeam < $< > $*.tex
