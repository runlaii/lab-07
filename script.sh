#!/bin/bash

for number in 1 2 3 4
do 
    input_dir="Testcase${number}"
    output_dir="Testcase${number}Diff"

    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt
    do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"


        if cmp -s "$file1" "$file2"
        then
            continue
        fi

        mkdir -p "$output_dir"

        filename="${file1##*/}"
        name="${filename%.1.txt}"

        diff -u "$file1" "$file2" > "$output_dir/${name}Diff.txt"
    done
done