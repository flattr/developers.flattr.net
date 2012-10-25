---
title: Subscriptions
---

#### List subscriptions

**Scope required**: flattr

##### Request
```
GET <%= @config[:api_url]%>/user/subscriptions
```

##### Example response

<%= headers(200) %>
<%= json(:subscription) {|t| [t]} %>

#### Create a new subscription
**Scope required**: flattr

##### Request
```
POST <%= @config[:api_url]%>/things/:id/subscriptions
```

##### Example response

<%= headers(200) %>
<%= json(:subscription_create)%>

##### Errors

* `insufficient_scope` (403 Forbidden) - **flattr** scope needed
* `thing_owner` (403 Forbidden) - Resource owner cannot subscribe to their own things
* `subscribed` (403 Forbidden) - Resource owner already subscribed to thing
* `not_found` (404 Not found) - Thing not found

#### Pause and start subscriptions
**Scope required**: flattr

##### Request
```
PUT <%= @config[:api_url]%>/things/:id/subscriptions
```

##### Example response when started
<%= headers(200) %>
<%= json(:subscription_start) %>

##### Example response when paused
<%= headers(200) %>
<%= json(:subscription_pause) %>

##### Errors

* `insufficient_scope` (403 Forbidden) - **flattr** scope needed
* `not_found` (404 Not found) - Not subscribed to a thing or no thing was found.

#### Delete a subscription
**Scope required**: flattr

##### Request

```
DELETE <%= @config[:api_url]%>/things/:id/subscriptions
```

##### Example response

<%= headers(204) %>
<br>
##### Errors

* `not_found` (404 Not found) - No thing or subscription found
