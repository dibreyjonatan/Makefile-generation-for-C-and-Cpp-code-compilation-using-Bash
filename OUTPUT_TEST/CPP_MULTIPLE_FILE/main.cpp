#include <iostream>
#include "math_utils.h"
#include "message.h"

int main() {
    print_message("Hello from main!");
    int result = square(5);
    print_message(("5 squared is: " + std::to_string(result)).c_str());
    return 0;
}
