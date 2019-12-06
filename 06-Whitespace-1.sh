source "${TEST_DIR}/funcs.bash"

regular_diff=true # We will use regular diff because the lines are so long
reference_output=""

test_start "Whitespace Handling"

reference_run "${TEST_DIR}/prep.sh" -d "${TEST_DIR}/test-fs" \
    blerpoblagoperatooogazoa floccinaucinihilipilification

run "${TEST_DIR}/../prep" -d "${TEST_DIR}/test-fs" \
    blerpoblagoperatooogazoa floccinaucinihilipilification

compare_outputs

test_end
