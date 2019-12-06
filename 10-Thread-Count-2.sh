source "${TEST_DIR}/funcs.bash"

test_start "Ensures the number of threads is limited properly"

for i in {1..5}; do
    threads=$(( i + 10 ))
    "${TEST_DIR}/../prep" -d / -t "${threads}" \
        this is a very large test of the project a \
        long time ago in a galaxy far far away &> /dev/null &
    job=${!}

    sleep 1
    detected_threads=$(grep Threads /proc/${job}/status | awk '{print $2}')
    echo "Number of active threads detected: ${detected_threads}"
    (( detected_threads-- )) # To account for the main thread
    kill -9 "${job}"

    if [[ ${threads} -eq ${detected_threads} ]]; then
        test_end 0
    fi
done

test_end 1
