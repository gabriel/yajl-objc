# For other targets see Project/Makefile and Project-IPhone/Makefile

docs:
	/Applications/Doxygen.app/Contents/Resources/doxygen
	cd Documentation/html && make install
	cd ~/Library/Developer/Shared/Documentation/DocSets/ && tar zcvpf YAJL.docset.tgz YAJL.docset
	mv ~/Library/Developer/Shared/Documentation/DocSets/YAJL.docset.tgz Documentation

gh-pages: docs
	git checkout gh-pages
	cp -R Documentation/html/* .
	rm -rf Documentation
	git commit -a -m 'Updating docs' &&  git push origin gh-pages
	git checkout master

