filename=dissertation

default:
	pdflatex ${filename}
	bibtex ${filename}||true
	makeindex ${filename}.nlo -s nomencl.ist -o ${filename}.nls
	pdflatex ${filename}
	pdflatex ${filename}

test:
	latexmk -interaction=nonstopmult -outdir=. -pdf -halt-on-error $(filename)

pdf: ps
	ps2pdf ${filename}.ps

pdf-print: ps
	ps2pdf -dColorConversionStrategy=/LeaveColorUnchanged -dPDFSETTINGS=/printer ${filename}.ps

text: html
	html2text -width 100 -style pretty ${filename}/${filename}.html | sed -n '/./,$$p' | head -n-2 >${filename}.txt

html:
	@#latex2html -split +0 -info "" -no_navigation ${filename}
	htlatex ${filename}

ps:	dvi
	dvips -t letter ${filename}.dvi

dvi:
	latex ${filename}
	bibtex ${filename}||true
	latex ${filename}
	latex ${filename}

read:
	okular ${filename}.pdf &

aread:
	acroread ${filename}.pdf

clean:
	rm -f *.{ps,pdf,log,aux,out,dvi,bbl,blg,toc,nav,snm,synctex.gz,4ct,4tc,html,idv,lg,tmp,xref,css,vrb,nlo,nls,rel,ilg,ind,idx} *~

all :	default
