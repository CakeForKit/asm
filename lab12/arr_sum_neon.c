#include <stdio.h>
#include <string.h>

void arr_add(double *arr1, double *arr2, double *res, int len)
{
    int ind = 0;
    for (int i = 0; i < len / 2; i++)
    {
        double *r = res + ind;
        __asm__ __volatile__(
            "ld1 {v0.2d}, [%[arr1]]\n"        // Загружает в регистр адрес данных и затем использует этот адрес для загрузки в регистр реальных данных.
            "ld1 {v1.2d}, [%[arr2]]\n"        // ld1 из за проблем с переносом little-big endian 
            "fadd v2.2d, v0.2d, v1.2d\n" 
            "st1 {v2.2d}, [%[res]]\n"       // сохраняет данные по определенному адресу
            : [res] "=r"(r)
            : [arr1] "r"(&(arr1[ind])), [arr2] "r"(&(arr2[ind]))
            : "v0", "v1", "v2");
        memmove(&(res[ind]), r, 2 * sizeof(double));
        ind += 2;
    }
    
    if (len % 2 != 0)
        res[len - 1] = arr1[len - 1] + arr2[len - 1];
}

void print_arr(double *arr, int len)
{
    for (int i = 0; i < len; ++i)
        printf("%lf ", arr[i]);
    printf("\n");
}

#define N 5

int main(void)
{
    int len = N;
    double arr1[N] = {1.0, 2.0, 3.0, 4.0, 5.0};
    double arr2[N] = {0.1, 0.2, 0.3, 0.4, 0.5};
    double res[N];

    arr_add(arr1, arr2, res, len);

    printf("Arr 1: ");
    print_arr(arr1, len);
    printf("Arr 2: ");
    print_arr(arr2, len);
    printf("Res: ");
    print_arr(res, len);

    return 0;
}