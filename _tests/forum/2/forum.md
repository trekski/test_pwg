---
layout: default
pagination: 
  enabled: true # change to true to see simple pagination work
  collection: threads
  category: '2'
breadcrumbs:
    - name: Lista For
      href: ../../forum_list.html
    - name: Ogólne
      href: ../../forum/2/index.html
---
{% for thread in paginator.posts %}
  <h1>{{ thread.topic }}</h1>
{% endfor %}