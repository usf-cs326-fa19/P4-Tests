source "${TEST_DIR}/funcs.bash"

test_start "Memory Leak Check"

valgrind --leak-check=full \
    "${TEST_DIR}/../prep" -d "${TEST_DIR}/test-fs" -t 50 \
        this is only a test \
    | grep 'are definitely lost'
[[ $? -eq 1 ]]

test_end
