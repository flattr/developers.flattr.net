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

<%= headers(200, "Content-Type" => "application/stream+json") %>
<%= json(:activities) %>

##### Errors

* `not_found` (404 Not Found) - The requested user could not be found

#### List a authenticated users activities

*[Authentication](#authenticated_call) needed*

##### Parameters

* **type** ( _Optional_ ) - Can be set to `incoming` or `outgoing`, default: `outgoing`

##### Request

```
GET <%=@config[:api_url]%>/user/activities
```

##### Example response

<%= headers(200, "Content-Type" => "application/stream+json") %>
<%= json(:activities) %>

##### Errors

* `unauthorized` (401 Unauthorized) - You are unauthorized to access the resource (invalid bearer token supplied)
