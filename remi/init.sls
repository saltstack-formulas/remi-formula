# Completely ignore non-CentOS, non-RHEL systems
{% if grains['os_family'] == 'RedHat' %}
include:
  - .pkgrepo
{% if 'modules' in salt['pillar.get']('remi') %}
  - .modules
{% endif %}
{% endif %}