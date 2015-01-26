#!/bin/bash

domains="$*"
app="speechcms"

. ~/bin/function.sh

for domain in $domains; do
  echo "handle $domain ... "
  rm -rvf grails-app/views/$domain/
  Domain=$(tocap1 "$domain")
  grails generate-view $app.$Domain
done

