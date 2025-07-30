#include "utils.h"
#include <string.h>
#include <ctype.h>

size_t count_vowels(const char *str) {
    size_t count = 0;
    for (size_t i = 0; str[i] != '\0'; i++) {
        char c = tolower(str[i]);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
            count++;
        }
    }
    return count;
}

bool is_palindrome(const char *str) {
    size_t len = strlen(str);
    for (size_t i = 0; i < len / 2; i++) {
        if (str[i] != str[len - i - 1]) {
            return false;
        }
    }
    return true;
}

void reverse_string(char *str) {
    size_t len = strlen(str);
    for (size_t i = 0; i < len / 2; i++) {
        char tmp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = tmp;
    }
}

int find_max(const int arr[], size_t size) {
    if (size == 0) return -1;
    int max = arr[0];
    for (size_t i = 1; i < size; i++) {
        if (arr[i] > max) max = arr[i];
    }
    return max;
}

void to_uppercase(char *str) {
    for (size_t i = 0; str[i] != '\0'; i++) {
        str[i] = toupper(str[i]);
    }
}
