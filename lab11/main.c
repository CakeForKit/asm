#include <iostream>
#include <cstring>

int main()
{
    char a[100];
    std::cout << "Enter password: ";
    std::cin >> a;
    if (strcmp(a, "1234") == 0) {
        std::cout << "access granted";
    }
    else {
    std::cout << "access denied";
}
}