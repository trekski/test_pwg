---
layout: default
pagination: 
  enabled: true # change to true to see simple pagination work
  collection: threads
  category: '3'
breadcrumbs:
    - name: Lista For
      href: ../../forum_list.html
    - name: Informacje
      href: ../../forum/3/index.html
---
{% for thread in paginator.posts %}
  <h1>{{ thread.topic }}</h1>
{% endfor %}