target = assignment6

all: run_$(target)

run_$(target): $(target).o input.o
	gcc -m32 -o run_$(target) $(target).o input.o

$(target).o: $(target).as
	nasm -f elf32 $(target).as -o $(target).o

input.o: input.c
	gcc -m32 -Wall -c input.c -o input.o

run: run_$(target)
	./run_$(target)

clean:
	rm -f *.o *.lst run_* ./*~
