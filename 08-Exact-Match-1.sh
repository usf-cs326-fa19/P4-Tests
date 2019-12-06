source "${TEST_DIR}/funcs.bash"

regular_diff=true # We will use regular diff because the lines are so long
reference_output="" # These searches should not output anything

test_start "Exact Match"

run "${TEST_DIR}/../prep" -d "${TEST_DIR}/test-fs" -e \
    HELLO WHATS COOKIN

compare_outputs || test_end

run "${TEST_DIR}/../prep" -d "${TEST_DIR}/test-fs" -e HeLLo

compare_outputs

test_end
