source "${TEST_DIR}/funcs.bash"
run_timeout=5
run_return=1

test_start "Invalid Directory" \
    "The program should not crash when given an invalid directory " \
"and should return EXIT_FAILURE to indicate failure."

run ./prep -t 1000 -e -d /this/does/not/exist xxx yyy zzz

test_end
