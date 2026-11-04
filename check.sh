#!/bin/bash

all_pass=1
for number in 1 2 3 4
do
    input_dir="Testcase${number}"
    output_dir="Testcase${number}Diff"

    passed=1
    has_difference=0

    for file1 in "$input_dir"/*.1.txt
    do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        filename="${file1##*/}"
        name="${filename%.1.txt}"
        output_file="$output_dir/${name}Diff.txt"

        if cmp -s "$file1" "$file2"
        then
            if [ -e "$output_file" ]
            then
                passed=0
            fi
        else
            has_difference=1

            if [ ! -f "$output_file" ]
            then
                passed=0
            else
                if ! cmp -s \
                    <(diff -u "$file1" "$file2" | tail -n +3) \
                    <(tail -n +3 "$output_file")
                then
                    passed=0
                fi
            fi
        fi
    done

    if [ "$has_difference" -eq 1 ]
    then
        if [ ! -d "$output_dir" ]
        then
            passed=0  
        fi
    else
        if [ -e "$output_dir" ]
        then
            passed=0
        fi
    fi

    if [ "$passed" -eq 1 ]
    then
        echo "Testcase${number}: PASS"
    else
        echo "Testcase${number}: FAIL"
        all_pass=0
    fi
done

if [ "$all_pass" -eq 1 ]
then
    exit 0
else
    exit 1
fi