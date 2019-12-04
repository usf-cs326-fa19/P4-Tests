test_file_name="$(basename "${0}")"
test_num="${test_file_name%%-*}"
test_pts="${test_file_name##*-}"
test_pts="${test_pts/.sh/}"
test_name="${test_file_name%-*}"
test_name="${test_name##*-}"
in_test=false
regular_diff=false
program_output=""
filtered_output=""
reference_output=""
run_timeout=0
run_return=0
max_lines=1000

exec &> "${TEST_DIR}/test.${test_num}.md"

test_start() {
    if [[ ${in_test} == true ]]; then
        echo "FATAL: Entering test block failed: missing 'test_end'?"
        exit 1
    fi
    in_test=true
    ((test_count++))
    echo "## Test ${test_num}: ${1} [${test_pts} pts]"
    if [[ -n ${2} ]]; then
        echo
        echo "${2}"
    fi
    echo
    echo '```'
    trace_on
}

test_end() {
    return=${?}
    if [[ -n ${1} ]]; then
        return=${1}
    fi

    if [[ "${return}" -eq 139 ]]; then
        echo '--------------------------------------------'
        echo ' --> ERROR: program terminated with SIGSEGV '
        echo '--------------------------------------------'
        echo
    fi

    if [[ "${return}" -eq 124 ]]; then
        echo '--------------------------------------------'
        echo " --> ERROR: program timed out (${run_timeout}s) "
        echo '--------------------------------------------'
        echo
    fi

    if [[ ${return} -ne "${run_return}" ]]; then
        echo " --> Test failed (${return})"
        # Set return to a nonzero value to tell the grader that the test failed.
        return=1
    else
        # If the return value matches the expected return value (run_return),
        # then we set it to 0 here so that the test case passes.
        return=0
    fi

    { trace_off; } 2> /dev/null
    in_test=false
    echo -e '```'"\n"
    exit "${return}"
}

trace_on() {
    set -v
}

trace_off() {
    { set +v; } 2> /dev/null
}

run() {
    program_output=$(timeout ${run_timeout} ${@})
    program_return=$?

    if [[ ${run_nocheck} == true ]]; then
        return "${program_return}"
    fi

    if [[ "${program_return}" -ne "${run_return}" ]]; then
        test_end "${program_return}"
    else
        return "${run_return}"
    fi
}

reference_run() {
    reference_output=$(${@})
    return $?
}

filter() {
    filtered_output=$(grep -iE ${@} <<< "${program_output}")
    matches=0
    if [[ -n "${filtered_output}" ]]; then
        matches=$(wc -l <<< "${filtered_output}") 
    fi
    echo " --> Filter matched ${matches} line(s)"
}

draw_sep() {
    local term_sz="$(tput cols)"
    local half=$(((term_sz - 1) / 2))
    local midpoint="${1}"
    if [[ -z "${midpoint}" ]]; then
        midpoint='-'
    fi

    for (( i = 0 ; i < half ; ++i )); do
        echo -n "-"
    done
    echo -n "${midpoint}"
    for (( i = 0 ; i < (( half - (term_sz % 2))); ++i )); do
        echo -n "-"
    done
    echo
}

compare_outputs() {
    compare ${@} <(echo "${reference_output}") <(echo "${program_output}")
}

compare() {
    echo
    local result=''
    if [[ ${regular_diff} == true ]]; then
        echo "-- diff of outputs shown below --"
        diff ${@}
        result=${?}
        echo "---------------------------------"
    else
        local term_sz="$(tput cols)"
        local half=$(((term_sz - 1) / 2))
        printf "%-${half}s| %s\n" "Expected Program Output" "Actual Program Output"
        draw_sep 'V'
        sdiff --expand-tabs --width="${term_sz}" ${@}
        result=${?}
        draw_sep '^'
    fi
    echo -n " --> "
    if [[ ${result} -eq 0 ]]; then
        echo "OK"
        # Return run_return here instead of 0 just in case the test is configured to
        # expect nonzero values to pass.
        return ${run_return}
    else
        echo "FAIL"
        return 255
    fi
}

fake_tty() {
    timeout 5 script --flush --quiet --command "$(printf "%q " "$@")" /dev/null
}

choose_port() {
    while true; do
        port=$[10000 + ($RANDOM % 1000)]
        (echo "" > /dev/tcp/127.0.0.1/${port}) > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $port
            break
        fi
    done
}

wait_port() {
    local port="${1}"
    while true; do
        (echo "" > /dev/tcp/127.0.0.1/${port}) > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            sleep 0.25
        else
            break
        fi
    done
}

stop_server() {
    kill -- -$1
}
