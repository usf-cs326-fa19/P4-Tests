#!/usr/bin/env bash

grep_args="--ignore-case"
exact=false
startdir="."

prep() {
    echo "Searching for ${1} in ${startdir}" 1>&2
    output=$(grep --with-filename --binary-files=without-match -Rnw ${grep_args} ${1} ${startdir})
    if [[ -z "${output}" ]]; then
        return 0
    fi

    IFS=$'\n'
    for line in $(echo "${output}"); do
        rel_path=$(cut -d':' -f1 <<< "${line}")
        abs_path=$(realpath "${rel_path}")

        line_no=$(cut -d':' -f2 <<< "${line}")

        line_content=$(cut -d':' -f3 <<< "${line}")
        trim_line=$(sed 's/^[ \t]*//;s/[ \t]*$//' <<< "${line_content}")

        my_uid=$(id -u)
        my_gid=$(id -g)

        file_uid=$(stat --format '%u' "${abs_path}")
        file_gid=$(stat --format '%g' "${abs_path}")

        full_perms=$(stat --format '%A' "${abs_path}")

        perms=""

        if [[ "${my_uid}" == "${file_uid}" ]]; then
            perms="o${full_perms:1:3}"
        elif [[ "${my_gid}" == "${file_gid}" ]]; then
            perms="-${full_perms:4:3}"
        else
            perms="-${full_perms:7:3}"
        fi

        printf "[ %s | %s | %s | %s ]\n" \
            "${abs_path}" \
            "${line_no}" \
            "${perms}" \
            "${trim_line}"
    done
}

while getopts "d:et:" flag; do
    case ${flag} in
        d) startdir=${OPTARG} ;;
        e) exact=true ;;
        t) ;;
        ?) exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if [[ ${exact} == true ]]; then
    grep_args=""
fi

for i in ${@}; do
    prep ${i}
done
