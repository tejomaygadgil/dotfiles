#!/bin/bash
# Inspired by https://github.com/mischavandenburg/dotfiles/blob/main/scripts/zet

zetdir=~/workspace/notes/zet/0-inbox

# Get the filename
prompt_filename() {
  read -p "Name of zettel: " zettel_name
  echo "$zettel_name"
}
if [[ $# -eq 1 ]]; then
	filename=$1
elif [[ $# -eq 0 ]]; then
	filename="$(prompt_filename)"
else
  echo "No spaces please!"
	filename="$(prompt_filename)"
fi

# Check formatting and uniquness
pattern="^[a-zA-Z0-9-]+$"
while ! [[ "$filename" =~ $pattern ]]; do
  echo "Alnum and dashes only"
  filename="$(prompt_filename)"
done
make_filepath() {
  echo "$zetdir/$filename.md"
}
filepath=$(make_filepath)
while [ -f "$filepath" ]; do
  echo "Already exists"
  filename=$(prompt_filename)
  filepath=$(make_filepath)
done

# Create and open
touch $filepath
{
  echo -en "# $filename \n\n"
} >>"$filepath"
nvim "$filepath"
