sync:
	rsync -arz --delete --exclude data --exclude log --exclude tmp /Users/genaim/private_gasol_with_ml genaim@costa2.fdi.ucm.es:/home/genaim

sync2:
	rsync -arz --delete --exclude data --exclude log --exclude tmp /Users/genaim/private_gasol_with_ml genaim@samir.fdi.ucm.es:/home/genaim

cleandata:
	rm -rf data
