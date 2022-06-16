#########################################################################
#
# config synchorization - check phase
#
() {
  (
  cd "$ENVCONF_ROOT"
  envconf_changes="$(git status --porcelain)"
  if [ -z $envconf_changes ]; then
    ;
  else
    echo "EnvConf dir is not clean, status:"
    echo $envconf_changes
  fi
  )
} &!
