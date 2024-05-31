#include <stdio.h>

int my_strlen(const char *str)
{
    int len;
    asm volatile (              //  64-разрдяный регистр X0-X30 или 32-разрядный регистр W0-W30
        "mov x0, %[str]\n"    
        "mov w1, #0\n"        

        "loop:\n"
        "ldrb w2, [x0], #1\n"   // загружаем из X0 один байт - один символ в W2 и увеличиваем адрес в X0 на 1
        "cbz w2, end_label\n"   // проверить регистр на 0 и в зависимости от результата проверки выполнить переход к некоторой метке   
        "add w1, w1, #1\n"      // ADD Xd, Xn, #imm    // Xd = Xn + #imm --> x1++
        "b loop\n"              // Безусловный переход     

        "end_label:\n"
        "mov %w[len], w1\n"    // %w[] - превращает переменную в скобка в 32битную
        : [len] "=r" (len)      
        : [str] "r" (str)      // Если указан ограничитель "r", то компилятор может сохранить значение в любом доступном регистре общего назначения
        : "x0", "x1", "w2"   
    );

    return len;
}

int main()
{
    int len;
    char messg[] = "Hello, world!";
    len = my_strlen(messg);
    printf("String length = %d\n", len);

    return 0;
}