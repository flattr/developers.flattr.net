---
title: Activities
kind: api-resource
nav: api
---

> Only Atom (.atom) and JSON (.as) Activity Streams responses supported

#### List an users activities

##### Request

```
GET <%= @config[:api_url]%>/users/:username/activities
```

##### Example response

<%= headers(200, {}, "Content-type: application/stream+json") %>
<%= json(:activities) %>

#### List a authenticated users activities

*[Authentication](#authenticated_call) needed*

##### Request

```
GET <%=@config[:api_url]%>/user/activities
```

##### Example response

<%= headers(200, {}, "Content-type: application/stream+json") %>
<%= json(:activities) %>
