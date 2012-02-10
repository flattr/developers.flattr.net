---
title: Fetch who flattrd a thing
kind: article
created_at: 2012-02-10
---

Now you can get information about who flattred a specific thing. Read
more about it in the [thing resource](http://developers.flattr.net/api/resources/flattrs/#list-a-things-flattrs).

Example (i have made the response shorter):

##### Request

```
GET <%= @config[:api_url]%>/things/313733/flattrs
```

##### Response
<%= headers(200) %>
<%= json(:flattr) {|t| [t]} %>


