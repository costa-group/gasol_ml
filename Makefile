sync:
	rsync -arz --delete --exclude data /Users/genaim/private_gasol_with_ml genaim@costa2.fdi.ucm.es:/home/genaim
cleandata:
	rm -rf data
