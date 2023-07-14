{%- set modules = salt['pillar.get']('remi:modules', {}) %}
{%- for module,config in modules.items() %}
{%- if config.get('reset', False) %}
reset-{{ module }}-module:
    cmd.run:
      - name: dnf module reset -y {{ module }}
{% endif %}

{%- if 'version' in config %}
install-{{ module }}-module-{{ config.version }}:
    cmd.run:
      - name: dnf module install -y {{ module }}:remi-{{ config.version }}
{% else %}
install-{{ module }}-module:
    cmd.run:
      - name: dnf module install -y {{ module }}:remi
{% endif %}
{% endfor %}
