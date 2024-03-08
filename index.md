---
layout: post
title: Blogging Like a Hacker
---

Welcome to My Home Page

{% assign date = '2020-04-13T10:20:00Z' %}

- Original date - {{ date }}
- With timeago filter - {{ date | timeago }}

- 
<h1>{{ page.title }}</h1>

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a> {{ post.food }}
    </li>
  {% endfor %}
</ul>
