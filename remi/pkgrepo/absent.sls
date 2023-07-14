{% set remi_settings = salt['pillar.get']('remi') %}
{% if 'repo' in remi_settings %}
{% for repo,_ in remi_settings.repo.items() %}
remove-{{ repo }}:
    pkgrepo.absent:
      - name: {{ repo }}
{% endfor %}
{% endif %}