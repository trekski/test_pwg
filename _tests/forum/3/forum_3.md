---
layout: default
forum: forum_3
pagination: 
  enabled: true
  collection: threads
  category: 'forum_3'
  per_page: 2
  sort_field: thread_order 
  trail: 
    before: 2
    after: 2

breadcrumbs:
    - name: Lista For
      href: ../../forum_list.html
    - name: Informacje
      href: ../../forum/3/index.html
---
<div class="threads_list">
{%- assign global_threads = site.threads | where: "thread_type", "global_thread" | sort: "thread_order" %}
{%- assign announcements = site.threads | where: "thread_type", "thread_announc" | where: "category", page.forum | sort: "thread_order" %}
{%- assign sticky_posts = site.threads | where: "thread_type", "thread_sticky"  | where: "category", page.forum | sort: "thread_order" %}
{%- assign plain_posts = paginator.posts | where: "thread_type", "" | sort: "thread_order" %}

{%- for t in global_threads %}
{% include thread_item.html thread = t %}
{%- endfor %}

{%- for t in announcements %}
{% include thread_item.html thread = t %}
{%- endfor %}

{%- if paginator.page == 1 -%}
  {%- for t in sticky_posts %}
  {% include thread_item.html thread = t %}
  {%- endfor %}
{%- endif -%}

{%- for t in plain_posts %}
{% include thread_item.html thread = t %}
{%- endfor %}
</div>

