---
layout: post
title: Blogging Like a Hacker
slug: 123
---

<h1>{{ page.title }}</h1>

{% for repository in site.github.public_repositories %}
  * [{{ repository.name }}]({{ repository.html_url }})
{% endfor %}
