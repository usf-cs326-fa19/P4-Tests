source "${TEST_DIR}/funcs.bash"
regular_diff=true # We will use regular diff because the lines are so long

test_start "Many-Term Search"

reference_run "${TEST_DIR}/prep.sh" -t 2 -e -d "${TEST_DIR}/test-fs" \
    Cochrone aquamarine Callistonian chandeliers encephalography encyclopedic institutionalized \
        | sort

run "${TEST_DIR}/../prep" -t 2 -e -d "${TEST_DIR}/test-fs" \
    Cochrone aquamarine Callistonian chandeliers encephalography encyclopedic institutionalized \
        | sort

compare_outputs

test_end
