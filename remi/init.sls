# A lookup table for remi GPG keys & RPM URLs for various RedHat releases
{% set pkg = salt['grains.filter_by']({
  'CentOS-5': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-5.rpm',
  },
  'CentOS-6': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-6.rpm',
  },
  'CentOS-7': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-7.rpm',
  },
}, 'osfinger') %}

# Completely ignore non-CentOS, non-RHEL systems
{% if grains['osfullname'] in ('CentOS', 'RHEL') %}

install_remi_pubkey:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    - source: {{ salt['pillar.get']('remi:pubkey', pkg.key) }}
    - source_hash:  {{ salt['pillar.get']('remi:pubkey_hash', pkg.key_hash) }}

include:
    - epel

install_remi_rpm:
  pkg.installed:
    - sources:
      - remi-release: {{ salt['pillar.get']('remi:rpm', pkg.rpm) }}
    - requires:
      - file: install_remi_pubkey
      - pkg: epel

{% if salt['pillar.get']('remi:disabled', False) %}
enable_remi:
  file.replace:
    - name: /etc/yum.repos.d/remi.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% else %}
disable_remi:
  file.replace:
    - name: /etc/yum.repos.d/remi.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% endif %}
{% endif %}
