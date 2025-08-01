#ifndef MATH_FUNCTIONS_H
#define MATH_FUNCTIONS_H

class MathUtils {
public:
    int Add(int a, int b);
    int Sub(int a, int b);
    int Mul(int a, int b);
    int Div(int a, int b); // returns 0 if b == 0
    bool IsEven(int n);
    int Factorial(int n);  // returns -1 if n < 0
};

#endif 
