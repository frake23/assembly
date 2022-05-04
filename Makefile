compile:
	nasm -f elf64 ./$(name)/$(name).asm -l ./$(name)/$(name).lst
	ld -o ./$(name)/$(name) ./$(name)/$(name).o
run:
	./$(name)/$(name)
debug:
	edb --run ./$(name)/$(name)
cr:
	make compile
	make run
d:
	make debug