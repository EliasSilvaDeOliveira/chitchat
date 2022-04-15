#
#--- MAKE para ChitChat rAVA's project
#

#--- https://www.digitalocean.com/community/tutorials/how-to-push-an-existing-project-to-github
#--- https://circleci.com/blog/pushing-a-project-to-github/
#--- https://stackoverflow.com/questions/14087667/create-a-remote-git-repo-from-local-folder
#--- https://stackoverflow.com/questions/6648995/how-to-create-a-remote-git-repository-from-a-local-one


#
#--- Cloud da Embratel
#
senhaRoot="3cr96ipzS"
SERVER=www.eliasdeoliveira.com.br
ravaSERVER=www.eliasdeoliveira.com.br:/var/www/rava/
ravaURL=http://www.eliasdeoliveira.com.br/rava/


#--- Chitchat Project
#    https://youtu.be/VjVpYPiIdEk  - The explanation of what is all about
#

clearAll:
	rm -f *~ *.dvi *.out *.aux *.log *.b[b,l]? 0*.pdf 

NOTANGLE =	notangle
NOWEAVE	 =	noweave


#
#--- The ChitChat Concepts ------------------------------------------------

readME:
	pdflatex chitchat-readME; bibtex chitchat-readME;
	pdflatex chitchat-readME; pdflatex chitchat-readME;
#	bibtool -x chitchat-readME.aux -o chitchat.bib
#	pandoc --bibliography=chitchat.bib \
		--wrap=preserve -o README.md chitchat-readME.tex

doc: readME
	cp chitchat.nw chitchat.tex
#---	Gera PDF
	pdflatex chitchat; bibtex chitchat; 
	pdflatex chitchat; pdflatex chitchat;


xx:

#	sshpass -p $(senhaRoot) scp ./rAVA.pdf \
		root@$(ravaSERVER)/rava.pdf
	sshpass -p $(senhaRoot) scp ./index-ravaSever-01.php \
		root@$(ravaSERVER)/index.php

#--- Upload do rAVA
upload:
	sshpass -p 'lcad-rii' scp ./masterBrain.php \
		rii-lcad@rii.lcad.inf.ufes.br:public_html/
	make aimlUpload -C mybots -f makefile


