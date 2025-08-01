#include "unity.h"
#include "cal.h"
#include "utils.h"
void test_add()
{
    int output = add(10, 20);
    TEST_ASSERT_EQUAL(30, output);
}
void test_sub_should_return_difference(void) {
    TEST_ASSERT_EQUAL(1, sub(3, 2));
}

void test_mul_should_return_product(void) {
    TEST_ASSERT_EQUAL(6, mul(2, 3));
}

void test_mul_should_return_negative_one_on_overflow(void) {
    TEST_ASSERT_EQUAL(-1, mul(INT_MAX, 2));
}

void test_div_should_return_quotient(void) {
    TEST_ASSERT_EQUAL(2, div(6, 3));
}

void test_div_should_return_zero_on_divide_by_zero(void) {
    TEST_ASSERT_EQUAL(0, div(1, 0));
}

void test_mod_should_return_remainder(void) {
    TEST_ASSERT_EQUAL(1, mod(10, 3));
}

void test_power_should_return_correct_result(void) {
    TEST_ASSERT_EQUAL(27, power(3, 3));
}

void test_power_two_should_return_square(void) {
    TEST_ASSERT_EQUAL(9, power_two(3));
}

void test_is_equal_should_return_true_if_equal(void) {
    TEST_ASSERT_TRUE(is_equal(4, 4));
}

void test_is_equal_should_return_false_if_not_equal(void) {
    TEST_ASSERT_FALSE(is_equal(4, 5));
}

void test_is_greater_should_return_true_if_first_is_larger(void) {
    TEST_ASSERT_TRUE(is_greater(5, 2));
}

void test_is_smaller_should_return_true_if_first_is_smaller(void) {
    TEST_ASSERT_TRUE(is_smaller(1, 5));
}

void test_fill_single_digit_positive_number_should_fill_array(void) {
    int arr[9] = {0};
    fill_single_digit_positive_number(arr, 9);
    for (int i = 0; i < 9; i++) {
        TEST_ASSERT_EQUAL(i + 1, arr[i]);
    }
}

void test_fill_single_digit_positive_number_should_ignore_if_too_small(void) {
    int arr[5] = {0};
    fill_single_digit_positive_number(arr, 5);
    for (int i = 0; i < 5; i++) {
        TEST_ASSERT_EQUAL(0, arr[i]);
    }
}

void test_true_as_string_should_return_true(void) {
    TEST_ASSERT_EQUAL_STRING("true", true_as_string());
}

void test_false_as_string_should_return_false(void) {
    TEST_ASSERT_EQUAL_STRING("false", false_as_string());
}

void test_count_vowels(void) {
    TEST_ASSERT_EQUAL(5, count_vowels("education"));
    TEST_ASSERT_EQUAL(0, count_vowels("bcdfg"));
}

void test_is_palindrome(void) {
    TEST_ASSERT_TRUE(is_palindrome("madam"));
    TEST_ASSERT_FALSE(is_palindrome("hello"));
}

void test_reverse_string(void) {
    char str[] = "hello";
    reverse_string(str);
    TEST_ASSERT_EQUAL_STRING("olleh", str);
}

void test_find_max(void) {
    int arr[] = {1, 5, 3, 9, 2};
    TEST_ASSERT_EQUAL(9, find_max(arr, 5));
    TEST_ASSERT_EQUAL(-1, find_max(NULL, 0));
}

void test_to_uppercase(void) {
    char str[] = "hello world";
    to_uppercase(str);
    TEST_ASSERT_EQUAL_STRING("HELLO WORLD", str);
}


void setUp(void) {
    // This function is run before EACH test
}

void tearDown(void) {
    // This function is run after EACH test
}

int main(void)
{
    UNITY_BEGIN();
    
    RUN_TEST(test_add);
    RUN_TEST(test_sub_should_return_difference);
    RUN_TEST(test_mul_should_return_product);
    RUN_TEST(test_mul_should_return_negative_one_on_overflow);
    RUN_TEST(test_div_should_return_quotient);
    RUN_TEST(test_div_should_return_zero_on_divide_by_zero);
    RUN_TEST(test_mod_should_return_remainder);
    RUN_TEST(test_power_should_return_correct_result);
    RUN_TEST(test_power_two_should_return_square);
    RUN_TEST(test_is_equal_should_return_true_if_equal);
    RUN_TEST(test_is_equal_should_return_false_if_not_equal);
    RUN_TEST(test_is_greater_should_return_true_if_first_is_larger);
    RUN_TEST(test_is_smaller_should_return_true_if_first_is_smaller);
    RUN_TEST(test_fill_single_digit_positive_number_should_fill_array);
    RUN_TEST(test_fill_single_digit_positive_number_should_ignore_if_too_small);
    RUN_TEST(test_true_as_string_should_return_true);
    RUN_TEST(test_false_as_string_should_return_false);

    RUN_TEST(test_count_vowels);
    RUN_TEST(test_is_palindrome);
    RUN_TEST(test_reverse_string);
    RUN_TEST(test_find_max);
    RUN_TEST(test_to_uppercase);
    UNITY_END();
    
    return 0;   
}