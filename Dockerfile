FROM chef/inspec:4.18

# copy cis tests to test-run image
COPY ./profiles/ /share/profiles/

COPY ./entrypoint.sh .

ENV CHEF_LICENSE="accept"
COPY inspec /etc/chef/accepted_licenses/inspec

ENTRYPOINT ["/bin/ash", "./entrypoint.sh"]

VOLUME ["/share"]
WORKDIR /share
