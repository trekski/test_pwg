---
layout: default
title: Blogging Like a Hacker
---

Welcome to My Home Page

{% assign date = '2020-04-13T10:20:00Z' %}

1. Original date - {{ date }}
2. With timeago filter - {{ date | timeago }}

{% for post in site.posts %}
* [{{ post.title }}]({{ site.baseurl }}{{ post.url }})  
  {{ post.content }}
{% endfor %}

