.PHONY: ii
ii:
	make -C ii
	ln -s ii/ii ii.bin

clean:
	make -C ii clean
	rm -f ./ii.bin
