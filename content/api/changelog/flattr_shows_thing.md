---
title: Flattr resource now returns a thing
kind: article
created_at: 2012-01-26
---

When you flattr a thing from the API you now get a small thing object if
the flattr was successful. It also returns a `location` but that
attribute is now deprecated in favour of the `thing` attribute.
`location` will be removed in due time.

##### Example request
```
POST <%=@config[:api_url]%>/things/423405/flattr
```

##### Example response
<%= headers(200) %>
<%= json(:flattr_create) %>
