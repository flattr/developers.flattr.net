---
title: Users
kind: api-resource
nav: api
---

#### Get a user

##### Request
```
GET <%= @config[:api_url] %>/users/:username
```

##### Example response
<%= headers(200) %>
<%= json(:user) %>

#### Get the authenticated user

*[Authentication](/rest/#authenticated_call) needed*

##### Request
    GET <%= @config[:api_url] %>/user

##### Example response
<%= headers(200) %>
<%= json(:user) %>

##### Response with scope `extendedread`
<%= headers(200) %>
<%= json(:user_extended) %>
