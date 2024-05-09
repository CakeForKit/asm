#include <iostream>
#include <ctime>


clock_t time_measure_sum(float a, float b) {
    clock_t start = clock();
    a + b;
    clock_t end = clock();
    return end - start;
}