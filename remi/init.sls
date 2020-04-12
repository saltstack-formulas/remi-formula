# Completely ignore non-CentOS, non-RHEL systems
{% if grains['os_family'] == 'RedHat' %}

# A lookup table for remi GPG keys & RPM URLs for various RedHat releases
{% set pkg = salt['grains.filter_by']({
  '5': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-5.rpm',
  },
  '6': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-6.rpm',
  },
  '7': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-7.rpm',
  },
  '8': {
    'key': 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
    'key_hash': 'md5=3abb4e5a7b1408c888e19f718c012630',
    'rpm': 'http://mirrors.mediatemple.net/remi/enterprise/remi-release-8.rpm',
  },
}, 'osmajorrelease') %}


{% set remi_settings = salt['pillar.get']('remi') %}

install_remi_pubkey:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    - source: {{ remi_settings.pubkey|default(pkg.key) }}
    - source_hash:  {{ remi_settings.pubkey_hash|default(pkg.key_hash) }}

include:
    - epel

install_remi_rpm:
  pkg.installed:
    - sources:
      - remi-release: {{ remi_settings.rpm|default(pkg.rpm) }}
    - requires:
      - file: install_remi_pubkey
      - pkg: epel

{% if remi_settings.disabled|default(False) %}
disable_remi:
  file.replace:
    - name: /etc/yum.repos.d/remi.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% else %}
enable_remi:
  file.replace:
    - name: /etc/yum.repos.d/remi.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% endif %}

{% if 'repo' in remi_settings %}
{% for repo,opts in remi_settings.repo.items() %}
{% if opts.disabled|default(False) %}
disable_{{ repo }}:
  file.replace:
    - name: /etc/yum.repos.d/{{ repo }}.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% else %}
enable_{{ repo }}:
  file.replace:
    - name: /etc/yum.repos.d/{{ repo }}.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% endif %}
{% endfor %}
{% endif %}

{% endif %}
