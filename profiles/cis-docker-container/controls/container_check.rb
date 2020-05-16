# frozen_string_literal: true
# https://github.com/dev-sec/cis-docker-benchmark/blob/master/controls/container_images.rb

control 'CIS-Docker-1.13.0-Benchmark-4.8' do
  impact 1.0
  title 'Remove setuid and setgid permissions in the images'
  desc 'Removing setuid and setgid permissions in the images would prevent privilege escalation attacks in the containers.
  Rationale: setuid and setgid permissions could be used for elevating privileges. While these permissions are at times legitimately needed, these could potentially be used in privilege escalation attacks. Thus, you should consider dropping these permissions for the packages which do not need them within the images.'

  tag 'docker'
  tag 'cis-docker-1.12.0': '4.8'
  tag 'cis-docker-1.13.0': '4.8'
  tag 'level:2'
  ref 'DevSec Linux Baseline', url: 'https://github.com/dev-sec/linux-baseline'
  ref 'Docker Security', url: 'http://www.oreilly.com/webops-perf/free/files/docker-security.pdf'
  ref 'Docker Security Cheat Sheet', url: 'http://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf'
  ref 'setuid - set user identity', url: 'http://man7.org/linux/man-pages/man2/setuid.2.html'
  ref 'setgid - set group identity', url: 'http://man7.org/linux/man-pages/man2/setgid.2.html'

  describe command('find / -perm +6000 -type f -exec ls -ld {} \; 2> /dev/null') do
    its('stdout') { should eq "" }
  end
end
