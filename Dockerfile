FROM chef/inspec:4.18

COPY inspec /etc/chef/accepted_licenses/inspec
ENV CHEF_LICENSE="accept"

# copy cis inspec profiles to image
COPY ./profiles/ /share/profiles/
VOLUME ["/share"]

# container runs inspec tests on start
COPY ./entrypoint.sh .
ENTRYPOINT ["/bin/ash", "./entrypoint.sh"]

WORKDIR /share
