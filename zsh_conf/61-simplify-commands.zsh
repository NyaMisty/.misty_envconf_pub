if [[ $+{commands[kernel32.dll]} = 1 ]]; then
  return
fi

__filter_path() {
  for i in "${(@k)commands}"; do
    lowerName=$i:l
    if [[ $lowerName == *.dll ]] || [[ $lowerName == *.mof ]] || [[ $lowerName == *.shim ]] || [[ $lowerName == *.nls ]] || [[ $lowerName == *.py ]]; then
      unset "commands[$i]"
    fi
  done

  return 0
}

__filter_path_preexec() {
  # Run __gnu_utils when the whoami command is not already rehashed.
  # This acts as a sign that we need to rehash all GNU utils.
  [ $+commands[kernel32.dll] = 1 ] && __filter_path
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec __filter_path_preexec
