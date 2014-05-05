.PHONY: ii clean

all:
	@./3ircbot.lua

init:
	git submodule foreach git pull
	make -C ii
	ln -s ii/ii ii.bin
	ln -s lua-tbox/tbox.lua


clean:
	make -C ii clean
	rm -f ./ii.bin ./tbox.lua
