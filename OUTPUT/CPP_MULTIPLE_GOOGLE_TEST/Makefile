#This Makefile was automatically generated using ./generate_makefile_from_bash.sh
#For any problem report bug by opening an issue in the github project
CC=g++
VALGRIND_OPTION=
CFLAG=-Wall -Wextra -Werror -pedantic -std=c++20  -Iinclude -Iutils  -I googletest/googletest/include -fprofile-arcs -ftest-coverage
COVERAGE=yes
BUILD_DIR=build
BIN = bin
OBJS_SRC=test/test_math_utils.cpp src/math_utils.cpp src/math_functions.cpp 
OBJS=$(patsubst %.cpp, %.o , $(OBJS_SRC))
ifeq ($(MAKECMDGOALS),)
$(error "error please pass a target, either clean or and run")
endif
.PHONY: clean run
clean :
	rm -r build/* ||:
	rm -r coverage_report ||:
run :bin 
	./$(BIN)
	@if [ $(COVERAGE) = yes ] ; then \
	lcov --directory . --capture --output-file coverage.info; \
	genhtml coverage.info --output-directory coverage_report; \
	mv coverage.info $(BUILD_DIR); \
	fi
	@mv *.gcda $(BUILD_DIR) || :
	@mv *.gcno $(BUILD_DIR) || :
	@find . -path $(BUILD_DIR) -prune -o -name *.gcda -type f -exec mv -t $(BUILD_DIR) -- {} + > /dev/null 2>&1 || :
	@find . -path $(BUILD_DIR) -prune -o -name *.gcno -type f -exec mv -t $(BUILD_DIR) -- {} + > /dev/null 2>&1 || : 
	@mv $^ $(BUILD_DIR)
bin : $(OBJS)
	$(CC) $(CFLAG) $^ -o  $(BIN)  -Lgoogletest/build/lib -lgtest_main -lgtest -lpthread
	@mv $^ $(BUILD_DIR)
%.o : %.cpp
	$(CC) -c $(CFLAG)  $^ -o $@
