source "${TEST_DIR}/funcs.bash"
regular_diff=true # We will use regular diff because the lines are so long

test_start "Thread Performance" \
    "Tests the performance improvement (>= 1.2 in at least 1 iteration of 3)"

for i in {1..3}; do
    run "${TEST_DIR}/../prep" -t 1 -d "${TEST_DIR}/test-fs" the
    run1="${program_runtime}"

    run "${TEST_DIR}/../prep" -t 2 -d "${TEST_DIR}/test-fs" the
    run2="${program_runtime}"

    awk '
    {
        improvement = ($1 / $2)
        printf "Speed improvement: %.2f\n", improvement
        printf "(Must be >= 1.2)\n"
        if (improvement < 1.2) {
            exit 1
        } else {
            exit 0
        }
    }' <<< "${run1} ${run2}"
    
    if [[ $? -eq 0 ]]; then
        test_end 0
    fi
done

test_end 1
