#ifndef UTILS_H
#define UTILS_H

#include <stddef.h>
#include <stdbool.h>

size_t count_vowels(const char *str);
bool is_palindrome(const char *str);
void reverse_string(char *str);
int find_max(const int arr[], size_t size);
void to_uppercase(char *str);

#endif
