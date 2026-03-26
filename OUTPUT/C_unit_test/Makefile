#This Makefile was automatically generated using ./generate_makefile_from_bash.sh
#For any problem report bug by opening an issue in the github project
CC=gcc
VALGRIND_OPTION=y
CFLAG=-Wall  -Werror -Wextra -std=c11 -Iinclude -Iutils  -IUnity/src -fprofile-arcs -ftest-coverage -g
COVERAGE=yes
BUILD_DIR=build
BIN = bin
OBJS_SRC=Unity/src/unity.c test/test_main.c src/utils.c src/cal.c 
OBJS=$(patsubst %.c, %.o , $(OBJS_SRC))
ifeq ($(MAKECMDGOALS),)
$(error "error please pass a target, either clean or and run")
endif
.PHONY: clean run
clean :
	rm build/* ||:
	rm -r coverage_report ||:
	rm valgrind.log ||:
run :bin 
	@if [ $(VALGRIND_OPTION) = y ] ; then \
	valgrind --leak-check=full --show-leak-kinds=all  --track-origins=yes --log-file=valgrind.log  ./$(BIN); \
	else \
		./$(BIN); \
	fi
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
	$(CC) $(CFLAG) $^ -o $(BIN)
	@mv $^ $(BUILD_DIR)
%.o : %.c
	$(CC) -c $(CFLAG)  $^ -o $@
