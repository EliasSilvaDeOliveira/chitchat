#
#--- MAKE para ChitChat rAVA's project
#

#
#--- Cloud da Embratel
#
senhaRoot="3cr96ipzS"
SERVER=www.eliasdeoliveira.com.br
ravaSERVER=www.eliasdeoliveira.com.br:/var/www/rava/
ravaURL=http://www.eliasdeoliveira.com.br/rava/


#--- Chitchat Project
#    https://youtu.be/VjVpYPiIdEk  - The explanation of what that is about
#

clearAll:
	rm -f *~ *.dvi *.out *.aux *.log *.b[b,l]? 0*.pdf 

NOTANGLE =	notangle
NOWEAVE	 =	noweave


#
#--- The ChitChat Concepts ------------------------------------------------

doc:
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


lista:  # esta lista é gerada no diretório
	# /home/elias/work/sources/ir/servicos/ via $make chama
	#
	sed '/^http/!d; s/http/\\item http/g' \
		lista-qA-rava-01.txt > lista-qA-rava-01.tex
	sed -i -e '11,$$d' lista-qA-rava-01.tex
	#
	sed '/^http/!d; s/http/\\item http/g' \
		lista-qA-rava-02.txt > lista-qA-rava-02.tex
	sed -i -e '11,$$d' lista-qA-rava-02.tex


#--- Construindo interface PHP/aLine 
#    https://stackoverflow.com/questions/5941832/php-using-regex-to-get-substring-of-a-string
#



#########################################################


# Ip: 200.137.66.172
# User: lcad-acesso
# Passwd: acesso-lcad

codigos: # http://rii.lcad.inf.ufes.br/~rii-lcad/
	sshpass -p 'lcad-rii' scp ./codes/helloWorld.php \
		rii-lcad@rii.lcad.inf.ufes.br:public_html/
	sshpass -p 'lcad-rii' scp ./codes/script-01.php \
		rii-lcad@rii.lcad.inf.ufes.br:public_html/
#
	sshpass -p 'lcad-rii' scp ./index.html \
		rii-lcad@rii.lcad.inf.ufes.br:public_html/

uploadx: doc
	bibtool -x Servicos.aux -o upload/eliasOliveira.bib
	cp /home/elias/work/defs/defs.tex \
		/usr/share/texmf/tex/plain/misc/noweb.sty \
		/usr/share/texmf/bibtex/bst/abntex/abnt-alf.bst \
		macros.tex intro-a-libServicos.tex \
		como-se-credenciar-para-usar-lcad.tex \
		como-se-credenciar-para-usar-nlcad.tex \
		download-de-binarios-nlcad.tex \
		substituindo-trecho-de-codigo.tex \
		upload/
	cp Servicos.nw upload/main.tex
	dos2unix upload/*.tex
	#
	#--- Alteracoes necessarias para compilacao no OverLeaf
	sed -i 's#/home/elias/work/defs/defs#./defs#g' ./upload/main.tex
	#
	# Package para Codificacao latin1 -> UTF8
	sed -i 's/\[latin1\]{inputenc}/\[utf8\]{inputenc}/' upload/main.tex
	sed -i '/\\bibliography{/d' upload/main.tex
	#--- Altera inclusao do BibTex
	sed -i '/\\bibliographystyle{/a \\\bibliography{eliasOliveira}' upload/main.tex



chama:
#	./busca-aline.sh "carro autônomo ufes" atribuna search
	./busca-aline.sh "Ethel Maciel" atribuna search | \
		sed 's/http/\nhttp/g; s/.pdf"]/.pdf\n/g' | \
		sed '/^http/!d'

extrai:
	wget http://pdf.redetribuna.com.br/2014/setembro/28-09-2014/no28091412.pdf \
		-O x.pdf
	pdftotext x.pdf x.txt

html: snipet-rava.nw snipet-intro.tex
	cp snipet-rava.nw snipet-rava.tex
	pdflatex snipet-rava; bibtex snipet-rava; 
	pdflatex snipet-rava; pdflatex snipet-rava; 
	mv snipet-rava.pdf snipet.pdf
	#
	latex2html snipet-rava.tex -split 0 -info "" \
		-title "rAVA" -html_version 5,math -no_navigation -dir html
	sshpass -p $(senhaRoot) scp -r html/* \
		root@$(ravaSERVER)/
	#
	#--- Form script dependency
	#    when sending deployScriptFORM to $(ravaSERVER) directory
	make deployScriptFORM \
		-C /home/elias/Drive/sources/currier/htmlForm -f makefile

interface: html	
	#
	#--- LOCAL
	#cp ./teste.html ./index.html
	#cp ./index-webPage.html ./rAVA.html
	rm -rf ./tmp/
	cat header.html form.html body.html > index-form.html
	#--- tmp
	mkdir tmp; cp ./*.html ./*.css ./tmp/
	sed -i "s#URLHOME#$(URLLOCAL)#g" ./tmp/*.*
	#----------------------------------------------------
	#sshpass -p $(senhaLOCAL) sudo \
		scp ./tmp/* $(LOCALHOST); \
	sshpass -p $(senhaLOCAL) sudo \
		scp ./mybots/* ./tmp/* $(LOCALHOST)/mybots/; \
	rm -rf ./tmp/
	#
	#--- www.eliasdeoliveira.com.br
	rm -rf ./tmp/; make -C ./mybots/ -f makefile clearAll;
	cat header.html form.html body.html > index-form.html
	#--- tmp
	mkdir tmp; cp ./*.html ./*.css ./tmp/
	sed -i "s#URLHOME#$(ravaURL)#g" ./tmp/*.*
	#----------------------------------------------------
	sshpass -p $(senhaRoot) \
		scp ./tmp/* root@$(ravaSERVER)/
	sshpass -p $(senhaRoot) \
		scp ./mybots/* root@$(ravaSERVER)/mybots/
	rm -rf ./tmp/


callRAVA:
	 curl -i -v -H  "Accept: application/json" \
			-H "Content-Type: application/json" \
		www.eliasdeoliveira.com.br/rava/index.php \
		-d '{"app": "rAVA", "query": "is dog a carnivore"}'


x:
	 curl -i -v -H  "Accept: application/json" \
			-H "Content-Type: application/json" \
		www.eliasdeoliveira.com.br/rava/rava.php \
		-d '{"rava": "is dog a carnivore"}'


# https://www.freecodecamp.org/news/how-to-start-using-curl-and-why-a-hands-on-introduction-ea1c913caaaa/
pp:
	curl -i -v -X POST \
		-d '{"msg":"123456"}' \
		-H "Content-Type: application/json" \
		http://localhost:8080
