#include <iostream>
#include <ctime>

const size_t COUNT = 1000000;


template <typename T>
clock_t time_measure_sum(T a, T b) {
    clock_t start = clock();
    a + b;
    clock_t end = clock();
    return end - start;
}

template <typename T>
clock_t time_measure_mul(T a, T b) {
    clock_t start = clock();
    a * b;
    clock_t end = clock();
    return end - start;
}

/*
Ограничитель операнда памяти (m)
Когда операнды находятся в памяти, какие-либо выполняемые операции 
будут происходить непосредственно в том месте памяти 
*/
template <typename T>
clock_t time_measure_sum_asm(T a, T b) {
    T res;
    clock_t start = clock();
    __asm__ (
        ".intel_syntax noprefix\n\t"    // Директива .intel_syntax меняет синтаксис AT&T на синтаксис Intel;
        "fld %1\n"  // Загрузить вещественное число в стек
        "fld %2\n"
        "faddp\n"   // Сложение с выталкиванием из стека 
        "fstp %0\n" // Считать вещественное число из стека 
        : "=m" (res)
        : "m" (a), "m" (b)
    );
    clock_t end = clock();
    return end - start;
}

template <typename T>
clock_t time_measure_mul_asm(T a, T b) {
    T res;
    clock_t start = clock();
    __asm__ (
        "fld %1\n"
        "fld %2\n"
        "fmulp\n"
        "fstp %0\n"
        : "=m" (res)
        : "m" (a), "m" (b)
    );
    clock_t end = clock();
    return end - start;
}

template <typename T>
void measure_experiment(size_t count = 1000) {
    clock_t sum_time = 0.0, mul_time = 0.0, sum_time_asm = 0.0, mul_time_asm = 0.0;
    T first = 123.123, second = 456.67;
    for (size_t i = 0; i < count; ++i) {
        sum_time += time_measure_sum(first, second);
        mul_time += time_measure_mul(first, second);
        sum_time_asm += time_measure_sum_asm(first, second);
        mul_time_asm += time_measure_mul_asm(first, second);
        first += 1.1;
        second += 1.1;
    }
    std::cout << "C++ Sum time: " << sum_time << " Mul time: " << mul_time << std::endl;
    std::cout << "Asm Sum time: " << sum_time_asm << " Mul time: " << mul_time_asm << std::endl;
}



int main() {
    std::cout << "float: " << std::endl;
    measure_experiment<double>(COUNT);
    std::cout << "double: " << std::endl;
    measure_experiment<float>(COUNT);
    return 0;
}