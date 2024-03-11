---
layout: watek
title: test
pagination: 
  enabled: true
  category: watek_2
---

hello????

<hr />
<ul>
{% for post in paginator.posts %}
<li> {{ post.title }}</li>
{% endfor %}
</ul>
<hr />