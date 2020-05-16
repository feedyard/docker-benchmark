  #!/bin/ash
inspec exec ./profiles/cis-docker-image --chef-license=accept-no-persist

if [[ $1 != 'distroless' ]]; then
  inspec exec ./profiles/cis-docker-container -t docker://"$CID" --chef-license=accept-no-persist
fi
