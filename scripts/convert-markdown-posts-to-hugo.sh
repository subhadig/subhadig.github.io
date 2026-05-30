#!/usr/bin/env bash

tmp_post="/tmp/tmp_post"
echo -n "" > "$tmp_post"

file="$1"

write_line() {
    echo "$1" >> "$tmp_post"
}

# Remove any preceding directories from the file path
slug=${file//*\/}
# Remove the date prefix and the ".md" extension from the file path
slug=${slug:11:-3}

front_matter_qualifier_cnt=0
ignore_line=0
orig_IFS=$IFS
# Set the IFS to blank to stop Word Splitting by read
export IFS=''
while read -r line; do
    case "$line" in
        '---')
            let front_matter_qualifier_cnt=front_matter_qualifier_cnt+1
            if [ $front_matter_qualifier_cnt -eq 1 ]; then
                write_line "$line"
            elif [ $front_matter_qualifier_cnt -eq 2 ]; then
                write_line "slug: $slug"
                write_line 'aliases:'
                write_line "- /${slug}.html"
                write_line "$line"
            elif [ $front_matter_qualifier_cnt -eq 3 ]; then
                ignore_line=1
            elif [ $front_matter_qualifier_cnt -eq 4 ]; then
                ignore_line=0
            fi
            ;;
        !\[*\]\(assets/*)
            # Add a slash before "assets" for any image link
            write_line ${line//\(assets/\(\/assets}
            ;;
        'type: post')
            ;;
        *)
            if [ $ignore_line -eq 0 ]; then
                write_line "$line"
            fi
            ;;
    esac
done < "$file"
export IFS="$orig_IFS"

mv "$tmp_post" "$file"
