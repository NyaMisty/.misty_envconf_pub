bindkey | grep -- '-shell-word' | while read line; do
  new_line=$(echo "$line" | sed 's/kill-shell-word$/kill-subword/')
  eval "bindkey $new_line"
done