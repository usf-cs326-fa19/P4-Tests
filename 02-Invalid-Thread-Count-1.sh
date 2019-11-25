source "${TEST_DIR}/funcs.bash"
run_timeout=5
run_return=1

test_start "Invalid Thread Count" \
    "Checks to make sure an invalid thread count is handled properly."

run ./prep -t -1 wow

run ./prep -t hello world

test_end
