target = assignment6

all: $(target)


$(target): $(target).o $(target).c
	gcc -m32 $(target).c $(target).o -o run_$(target)

$(target).o: $(target).as
	nasm -f elf32 $(target).as

run: $(target)
	./run_$(target)

clean:
	rm -f *.o *.lst run_*
