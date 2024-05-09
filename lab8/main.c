#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// первая принимает 1 параметр - указатель на строку, определяет длину строки и
// выполнена в виде ассемблерной вставки;

// вторая копирует строку с адреса, заданного одним указателем, по адресу,
// заданному другим указателем, и реализована в отдельном asm-файле. Функция
// должна принимать 3 параметра: два указателя и длину строки. Про
// расположение указателей в памяти и расстояние между ними заранее ничего не
// известно (первая строка может начинаться раньше второй или наоборот; строки
// могут перекрываться).

extern int copymem(char *, char *, int);


int test_len(char *str)
{
    int len = 0;
    __asm__ (
        ".intel_syntax noprefix\n\t"    // Директива .intel_syntax меняет синтаксис AT&T на синтаксис Intel;
        "mov ecx, 0xFFFFFFFF\n\t"
        "lea rdi, [%1]\n\t"     // загружаем адрес строки в rdi
        "mov al, 0\n\t"         // в AL символ для поиска
        "repne scasb\n\t"       // scasb - сравнивает содержимое AL с байтом по RDI
                                // repne - повторять пока не (ECX == 0 || ZF == 0)
        "mov eax, 0xFFFFFFFF\n\t"
        "sub eax, ecx\n\t"
        "dec eax\n\t"
        "mov %0, eax\n\t"   // записываем результат в len
        : "=r"(len)     // выходные операнды %0
        : "r"(str)      // входные операнды %1
        : "%eax"        // разрушаемые регистры 
        // Каждый описанный операнд затем может использоваться в ассемблерных инструкциях,
        // обращение к нему осуществляется по номеру с префиксом %. Нумерация начинается с 0, и идет
        // непрерывно, объединяя все элементы списков выходных и входных операндов. 
    );
    printf("str: '%s', len = %d\n", str, len);
    return len;
}

void test_copy(char *dst, char *src, int len_src)
{
    printf("before: %s - %s\n", dst, src);
    copymem(dst, src, len_src);
    printf("cpy:    %s - %s\t cpy_len = %d\n", dst, src, len_src);
}


int main()
{
    char *str = "1234";
    test_len(str);
    str = "1";
    test_len(str);
    str = "";
    test_len(str);
    printf("\n");
    
    {
        char src[] = "0123456789";
        char *dst = &src[2]; // => 2345678989
        int len = 3;
        test_copy(dst, src, len);
        printf("\n");
    }

    {
        char dst[] = "0123456789";
        char *src = &dst[2]; // => 2345678989
        int len = 8;
        test_copy(dst, src, len);
        printf("\n");
    }
    

    {
        char src[] = "333";
        char dst[] = "0120"; // => 2345678989
        int len = 2;
        test_copy(dst, src, len);
        printf("\n");
    }

    {
        char src[20] = "preved";
        char *dst = src+3; // => 2345678989
        int len = test_len(src);

        test_copy(dst, src, len);
        printf("res:    %s \n\n", dst);
        printf("\n");
    }

    return 0;
}