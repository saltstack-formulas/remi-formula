{%- set modules = salt['pillar.get']('remi:modules', {}) %}
{%- for module,config in modules.items() %}
{%- if config.get('reset', False) %}
reset-{{ module }}-module:
    cmd.run:
      - name: dnf module reset -y {{ module }}
{%- if 'version' in config %}
      - unless: dnf module list --enabled {{ module }}:remi-{{ config.version }}
{% else %}
      - unless: dnf module list --enabled {{ module }}:remi
{% endif %}
{% endif %}

{%- if 'version' in config %}
install-{{ module }}-module-{{ config.version }}:
    cmd.run:
      - name: dnf module install -y {{ module }}:remi-{{ config.version }}
      - unless: dnf module list --enabled {{ module }}:remi-{{ config.version }}
{% else %}
install-{{ module }}-module:
    cmd.run:
      - name: dnf module install -y {{ module }}:remi
      - unless: dnf module list --enabled {{ module }}:remi
{% endif %}
{% endfor %}
