
task=3

# g++ -std=c++20 -S -masm=intel -m80387 -mno-80387 short_main.cpp

if [[ $task == 1 ]] then
    g++ -c -masm=intel -m80387 -mno-80387 time_measure.cpp -o time_measure.o
    g++ time_measure.o -o app.exe
elif [[ $task == 2 ]] then
    gcc -masm=intel -c sinus.cpp -o sinus.o -lm
    gcc sinus.o -o app.exe
elif [[ $task == 3 ]] then 
    echo "1"
    # ./nasm -f elf64 ./func_root_asm.asm -o func_root_asm.o
    echo "2"
    gcc -c -masm=intel func_root.cpp -o func_root.o
    echo "3"
    gcc func_root.o -o app.exe
fi


# rm *.o
./app.exe