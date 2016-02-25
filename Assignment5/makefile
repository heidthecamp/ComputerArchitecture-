target = assignment5

all: $(target)


$(target): $(target).o
	ld -e _main -melf_i386 -o run_$(target) $(target).o

$(target).o: $(target).as
	nasm -f elf32 -o $(target).o -l $(target).lst $(target).as

run: $(target)
	./run_$(target)

clean:
	rm -f *.o *.lst run_*
