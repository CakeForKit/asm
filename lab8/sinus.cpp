#include <stdio.h>
#include <math.h>


double sin_pi_asm()                            
{
    double res;
    __asm__(
        ".intel_syntax noprefix\n\t"    // Директива .intel_syntax меняет синтаксис AT&T на синтаксис Intel;
        "fldpi\n\t"                     // Поместить в стек число pi
        "fsin\n\t"                      // Вычисляет синус числа, находящегося в ST(0), и сохраняет результат в этомже регистре.
        "fstp %0\n\t"                   // Считать вещественное число из стека 
        : "=m" (res)                  
    );

    return res;
}

double sin_half_pi_asm()                        // обёртка над ассемблерной вставкой, считающей sin(pi / 2)
{
    double res;
    const int two = 2;
    
    __asm__(
        "fldpi\n\t"                     // Поместить в стек число pi
        "fild %1\n\t"                    // Загрузитьцелое число в стек
        "fdivp\n\t"                     // ST(1) = ST(1)/ST(0)
        "fsin\n\t"                      // Вычисляет синус числа, находящегося в ST(0), и сохраняет результат в этомже регистре.
        "fstp %0\n\t"                   // Считать вещественное число из стека 
        : "=m" (res)                    // res - выходной параметр
        : "m" (two)                 
    );

    return res;
}

int main(void)
{
    printf("\nPI: \n");
    
    printf("sin(3.14) =         %.20f\n", sin(3.14));
    printf("sin(3.141596) =     %.20f\n", sin(3.141596));
    printf("sin(M_PI) =         %.20f\n", sin(M_PI));
    printf("ASM sin() =     %.20f\n", sin_pi_asm());

    printf("\nPI / 2: \n");
    printf("sin(3.14 / 2) =     %.20f\n", sin(3. / 2));
    printf("sin(3.141596 / 2) = %.20f\n", sin(3.141596 / 2));
    printf("sin(M_PI) =         %.20f\n", sin(M_PI_2));
    printf("ASM sin() =         %.20f\n", sin_half_pi_asm());

    // std::cout
    // printf("ASM sin(PI) =       " PRECISION "\n", sin_pi());
}



