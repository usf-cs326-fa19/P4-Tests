source "${TEST_DIR}/funcs.bash"

regular_diff=true # We will use regular diff because the lines are so long
reference_output="" # These searches should not output anything

test_start "Basic Searches"

run "${TEST_DIR}/../prep" -d "${TEST_DIR}/test-fs/xyz" sea

compare_outputs || test_end

run "${TEST_DIR}/../prep" -d "${TEST_DIR}/test-fs/xyz" sea blerpoblagoperatooogazoa

compare_outputs

test_end
