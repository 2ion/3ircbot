.PHONY: ii clean
ii:
	git submodule foreach git pull
	make -C ii
	ln -s ii/ii ii.bin

clean:
	make -C ii clean
	rm -f ./ii.bin
