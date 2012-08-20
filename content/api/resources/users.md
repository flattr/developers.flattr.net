---
title: Users
---

#### The User object
<%= response_fields(:user) %>

#### The Mini User object
<%= response_fields(:mini_user) %>

#### Get a user

##### Request
```
GET <%= @config[:api_url] %>/users/:username
```


##### Example response
<%= headers(200) %>
<%= json(:user) %>


##### Errors

* `not_found` (HTTP 404) - user does not exist

#### Get the authenticated user

*[Authorization](/api/#authorization) needed*

##### Request
```
GET <%= @config[:api_url] %>/user
```

##### Example response
<%= headers(200) %>
<%= json(:user) %>

##### Errors

* `unauthorized` (HTTP 401) - invalid credentials (bearer token) supplied

##### Response with scope `extendedread`
<%= headers(200) %>
<%= json(:user_extended) %>
