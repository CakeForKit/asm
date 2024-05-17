# load:
# 	sudo apt install libgtk-3-dev

LIBS := $(shell pkg-config --libs gtk+-3.0)
FLAG_LIBS := $(shell pkg-config --cflags gtk+-3.0)




run: app.exe
	./app.exe

# app.exe: main.c
	
# 	gcc -masm=intel -o func_root.o -c func_root.c 
# 	gcc main.o func_root.o $(LIBS) -L /usr/lib/x86_64-linux-gnu -o $@ -no-pie
	
app.exe: main.asm func_root.c
	nasm -f elf64 -o main.o main.asm
	gcc -masm=intel -o func_root.o -c func_root.c 
	gcc main.o func_root.o $(LIBS) -L /usr/lib/x86_64-linux-gnu -o $@ -no-pie


clean:
	rm *.o *.exe