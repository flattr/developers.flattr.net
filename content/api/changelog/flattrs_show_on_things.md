---
title: Flattrs show on things
kind: article
created_at: 2012-05-11
---

Now number of flattrs show up on things when requesting the flattr resource. Our small representations of things had everything you needed except the `flattrs`, but now they are there. This means that you can easily create lists without requesting to much information, speed is everything.

##### Example request
```
GET <%= @config[:api_url]%>/users/smgt/flattrs
```

##### Example response
<%= headers(200) %>
<%= json(:flattr) %>
