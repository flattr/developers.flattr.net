---
title: Activities
---

> Only Atom (.atom) and JSON (.as) Activity Streams responses supported

#### List an users activities

The default activities are outgoing activities, what the user has done.
If you instead want to get a users incoming activities set the `type`
parameter to `incoming`.

##### Parameters

* **type** ( _Optional_ ) - Can be set to `incoming` or `outgoing`, default: `outgoing`

##### Request

```
GET <%= @config[:api_url]%>/users/:username/activities
```

##### Example response

<%= headers(200, {}, "Content-type: application/stream+json") %>
<%= json(:activities) %>

##### Errors

* `user_not_found` (HTTP 404) - user does not exist

#### List a authenticated users activities

*[Authentication](#authenticated_call) needed*

##### Parameters

* **type** ( _Optional_ ) - Can be set to `incoming` or `outgoing`, default: `outgoing`

##### Request

```
GET <%=@config[:api_url]%>/user/activities
```

##### Example response

<%= headers(200, {}, "Content-type: application/stream+json") %>
<%= json(:activities) %>

##### Errors

* `unauthorized` (HTTP 401) - invalid credentials (bearer token) supplied
