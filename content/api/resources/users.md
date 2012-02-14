---
title: Users
---

#### Get a user

##### Request
```
GET <%= @config[:api_url] %>/users/:username
```

##### Example response
<%= headers(200) %>
<%= json(:user) %>

##### Errors

* `user_not_found` (HTTP 404) - user does not exist

#### Get the authenticated user

*[Authentication](/rest/#authenticated_call) needed*

##### Request
    GET <%= @config[:api_url] %>/user

##### Example response
<%= headers(200) %>
<%= json(:user) %>

##### Errors

* `unauthorized` (HTTP 401) - invalid credentials (bearer token) supplied

##### Response with scope `extendedread`
<%= headers(200) %>
<%= json(:user_extended) %>
