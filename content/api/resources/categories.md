---
title: Categories
kind: api-resource
nav: api
---

#### List categories

Fetch a list of all available categories.

##### Request
```
GET <%= @config[:api_url] %>/categories
```

##### Example response
<%= headers(200) %>
<%= json(:categories) %>
