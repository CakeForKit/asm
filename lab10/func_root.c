#include <stdio.h>

// Вариант 13 -> sin(x**2 + 5x), метод половинного деления

#define START 0.1
#define END 1.0
#define ITERS_COUNT 10

double my_func_sin(double x)
{
    double res;
    __asm__(  
        ".intel_syntax noprefix\n\t" 
        "mov %0, 5 \n\t"
        "fild %0     \n\t"
        "fld %1     \n\t"
        "fld %1     \n\t"   // stack = (x, x, 5)
        "fmulp      \n\t"   // st1 = st0 * st1          stack = (x**2, 5)
        "fstp %0    \n\t"   // записывает в res x ** 2  stack = (5)

        "fld %1     \n\t"   // stack = (x, 5)
        "fmulp       \n\t"   // stack = (5x)

        "fld %0     \n\t"   // stack = (x**2, 5x)
        "faddp       \n\t"   // st1 = x**2 + 5x
        "fsin           \n\t" 
        "fstp %0    \n\t"
        : "=m" (res)                    // %0 res - выходной параметр
        : "m" (x)                       // %1
    );

    return res;
}

double find_mid(double a, double b)
{
    double res;
    __asm__(  
        ".intel_syntax noprefix\n\t" 
        
        // c = (a + b) / 2
        "fld %1         \n\t"
        "fld %2         \n\t"   // stack = (b, a)
        "faddp          \n\t"   // stack = (a + b)
        "mov %0, 2 \n\t"
        "fild %0     \n\t"      // stack = (2, a + b)
        "fdivp          \n\t"   // stack = ((a + b) /  2))
        "fstp %0    \n\t"
        // "mov rax, %0    \n\t"   // tmpx = (a + b) /  2)
        // "mov %4, rax     \n\t"

        // rbx = func((a + b) / 2)
        // "movq xmm0, %0  \n\t"   // копирует 64 разряда
        // "call %3        \n\t"   // rax = func((a + b) / 2)
        // "mov %0, rax    \n\t"

        : "=m" (res)                    // %0 res - выходной параметр
        : "m" (a), "m" (b) //, "m" (func) // a, b, func - %1, %2, %3
        : "rax", "xmm0", "rdx"
    );

    return res;
}


double find_root(double ina, double inb, int iters) 
{
    double fa, fb, fc, c;
    double a = ina, b = inb;
    for (int i = 0; i < iters; i++)
    {
        fa = my_func_sin(a);
        fb = my_func_sin(b);
        c = find_mid(a, b);
        fc = my_func_sin(c);

        if (fa * fc <= 0)
            b = c;
        else
            a = c;
    }
    printf("RESULT in func %lf\n", c);
    return c;
}

void my_funcin(double a, double b, int c)
{
    printf("--------------------- %lf %lf %d\n", a, b, c);
}

double my_funcpp()
{
    // printf("---------------------%lf\n", a);
    double c = 1.3;
    return c;
}

// int main(void)
// {
//     double a = 0.3, b = 0.6, c;
//     size_t iters = 10;
    
//     double root = find_root(a, b, iters);
//     printf("root = %f\n", root);
    

//     return 0;
// }


