#########################################################################
#
#
# History forgetting utils to avoid polluting history with typos
#
#

# Put a space at the start of a command to make sure it doesn't get added to the history.
setopt histignorespace

alias hu=' my_remove_last_history_entry' # Added a space in 'my_remove_last_history_entry' so that zsh forgets the 'forget' command :).

# ZSH's history is different from bash,
# so here's my fucntion to remove
# the last item from history.
my_remove_last_history_entry() {
    # This sub-function checks if the argument passed is a number.
    # Thanks to @yabt on stackoverflow for this :).
    is_int() ( return $(test "$@" -eq "$@" > /dev/null 2>&1); )

    # Set history file's location
    history_file="${HOME}/.zsh_history"
    history_temp_file="${history_file}.tmp"
    line_cout=$(wc -l $history_file)

    # Check if the user passed a number,
    # so we can delete x lines from history.
    lines_to_remove=1
    if [ $# -eq 0 ]; then
        # No arguments supplied, so set to one.
        lines_to_remove=1
    else
        # An argument passed. Check if it's a number.
        if $(is_int "${1}"); then
            lines_to_remove="$1"
        else
            echo "Unknown argument passed. Exiting..."
            return
        fi
    fi

    # Make the number negative, since head -n needs to be negative.
    lines_to_remove="-${lines_to_remove}"

    fc -W # write current shell's history to the history file.

    # Get the files contents minus the last entry(head -n -1 does that)
    #cat $history_file | head -n -1 &> $history_temp_file
    cat $history_file | head -n "${lines_to_remove}" &> $history_temp_file
    mv "$history_temp_file" "$history_file"

    fc -R # read history file.
}
