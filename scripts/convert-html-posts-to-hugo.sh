#!/usr/bin/env bash

tmp_post="/tmp/tmp_post"
echo -n "" > "$tmp_post"

file="$1"

write_line() {
    final_line="$1"
    final_line="${final_line//\{\{ site.baseurl \}\}}"
    echo "$final_line" >> "$tmp_post"
}

# Remove any preceding directories from the file path
slug=${file//*\/}
# Remove the date prefix and the ".html" extension from the file path
slug=${slug:11:-5}

front_matter_qualifier_cnt=0
orig_IFS=$IFS
# Set the IFS to blank to stop Word Splitting by read
export IFS=''
while read -r line; do
    case "$line" in
        '---')
            let front_matter_qualifier_cnt=front_matter_qualifier_cnt+1
            if [ $front_matter_qualifier_cnt -eq 2 ]; then
                write_line "slug: $slug"
                write_line 'aliases:'
                write_line "- /${slug}.html"
            fi
            write_line "$line"
            ;;
        'type: post')
            ;;
        *)
            write_line "$line"
            ;;
    esac
done < "$file"
export IFS="$orig_IFS"

mv "$tmp_post" "$file"
