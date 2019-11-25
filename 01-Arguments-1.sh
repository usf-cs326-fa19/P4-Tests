source "${TEST_DIR}/funcs.bash"
run_timeout=10
run_return=1

test_start "No Arguments" \
"If no arguments are provided, print usage information and quit. If -h is" \
"specified, the program should only print usage information."

reference_run ./prep -h

run ./prep

compare_outputs

run ./prep -h -t 1 -d ../../ ini

compare_outputs

test_end
