source "${TEST_DIR}/funcs.bash"

regular_diff=true # We will use regular diff because the lines are so long
reference_output="" # These searches should not output anything

test_start "Searches the local (non-test) file system for matches."

reference_run "${TEST_DIR}/prep.sh" -d /usr/share hippopotamus | sort

run "${TEST_DIR}/../prep" -d /usr/share hippopotamus | sort

compare_outputs || test_end

reference_run "${TEST_DIR}/prep.sh" -d /usr/share/nano color | sort

run "${TEST_DIR}/../prep" -d /usr/share/nano color | sort

compare_outputs

test_end
