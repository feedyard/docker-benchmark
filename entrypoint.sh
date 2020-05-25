  #!/bin/ash
inspec exec ./profiles/cis-docker-image --chef-license=accept-no-persist
echo $IMAGE_NAME
echo $IMAGE_TAG
echo $CONTAINER_USER
if [[ $1 != 'distroless' ]]; then
  inspec exec ./profiles/cis-docker-container -t docker://"$CID" --chef-license=accept-no-persist
fi
