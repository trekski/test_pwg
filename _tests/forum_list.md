---
layout: default
breadcrumbs:
    - name: Lista For
      href: '#'
---
{%- for g in site.data.lista_for%}
<div class="forum_group">
    <div>
        {{ g.grp_name }}
    </div>
    <div>
        {%- for f in g.fora %}
        {% include forum_item.html forum = f %}
        {%- endfor %}
    </div>
</div>
{%- endfor %}