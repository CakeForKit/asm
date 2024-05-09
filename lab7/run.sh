echo "1"
./nasm -f elf64 ./copymem.asm -o copymem.o  # -f <format> => elf64 - format: Выходной формат elf генерирует объектные файлы
echo "2"
gcc -c -masm=intel main.c -o main.o
echo "3"
gcc main.o copymem.o -o app.exe
echo "4"
# rm *.o
./app.exe