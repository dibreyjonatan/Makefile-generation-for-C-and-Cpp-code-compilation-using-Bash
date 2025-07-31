#include "math_functions.h"

int MathUtils::Add(int a, int b) {
    return a + b;
}

int MathUtils::Sub(int a, int b) {
    return a - b;
}

int MathUtils::Mul(int a, int b) {
    return a * b;
}

int MathUtils::Div(int a, int b) {
    return (b == 0) ? 0 : a / b;
}

bool MathUtils::IsEven(int n) {
    return n % 2 == 0;
}

int MathUtils::Factorial(int n) {
    if (n < 0) return -1;
    int result = 1;
    for (int i = 2; i <= n; ++i) {
        result *= i;
    }
    return result;
}
