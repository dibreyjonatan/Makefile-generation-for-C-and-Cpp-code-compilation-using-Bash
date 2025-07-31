#include "gtest/gtest.h"
#include "math_utils.h"       // for MathUtils class
#include "math_functions.h"   // for add, multiply, is_even functions

// ---------- Tests for the class MathUtils ---------- //
class MathUtilsTest : public ::testing::Test {
protected:
    MathUtils math;
};

TEST_F(MathUtilsTest, Add) {
    EXPECT_EQ(math.Add(3, 4), 7);
    EXPECT_EQ(math.Add(-1, 1), 0);
}

TEST_F(MathUtilsTest, Sub) {
    EXPECT_EQ(math.Sub(10, 4), 6);
    EXPECT_EQ(math.Sub(5, 10), -5);
}

TEST_F(MathUtilsTest, Mul) {
    EXPECT_EQ(math.Mul(3, 4), 12);
    EXPECT_EQ(math.Mul(0, 5), 0);
}

TEST_F(MathUtilsTest, Div) {
    EXPECT_EQ(math.Div(10, 2), 5);
    EXPECT_EQ(math.Div(5, 0), 0); // division by zero returns 0
}

TEST_F(MathUtilsTest, IsEven) {
    EXPECT_TRUE(math.IsEven(4));
    EXPECT_FALSE(math.IsEven(5));
}

TEST_F(MathUtilsTest, Factorial) {
    EXPECT_EQ(math.Factorial(5), 120);
    EXPECT_EQ(math.Factorial(0), 1);
    EXPECT_EQ(math.Factorial(-3), -1);
}

// ---------- Tests for standalone C-style functions ---------- //
TEST(MathFunctionsTest, Add) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
}

TEST(MathFunctionsTest, Multiply) {
    EXPECT_EQ(multiply(4, 5), 20);
    EXPECT_EQ(multiply(0, 99), 0);
}

TEST(MathFunctionsTest, IsEven) {
    EXPECT_TRUE(is_even(2));
    EXPECT_FALSE(is_even(3));
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
