sync:
	rsync -arz --delete /Users/genaim/private_gasol_with_ml genaim@costa2.fdi.ucm.es:/home/genaim
cleandata:
	rm -rf data
