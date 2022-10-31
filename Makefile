sync:
	rsync -arz --delete --exclude data --exclude saved_models /Users/genaim/private_gasol_with_ml genaim@costa2.fdi.ucm.es:/home/genaim
cleandata:
	rm -rf data
