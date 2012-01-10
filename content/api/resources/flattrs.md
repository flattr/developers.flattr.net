---
title: Flattrs
kind: api-resource
nav: api
---

#### List a users flattrs

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive ( default: 30 )
- **page** ( _Optional_ ) - Page of results to retreive (first page is 1)

##### Request
```
GET <%= @config[:api_url]%>/users/:username/flattrs
```

##### Example response
<%= headers(200) %>
<%= json(:flattr) {|t| [t]} %>

####  List the authenticated users flattrs

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive
- **page** ( _Optional_ ) - Page of results to retreive

##### Request
```
GET <%= @config[:api_url]%>/user/flattrs
```

##### Example response
<%= headers(200) %>
<%= json(:flattr) {|t| [t]} %>

#### Flattr a thing

**Scope required**: flattr

##### Request
```
POST <%= @config[:api_url] %>/things/:id/flattr
```

##### Example response
<%= headers(200) %>
<%= json(:flattr_create) %>

#### Flattr a autosubmit URL

**Scope required**: flattr

The flattr resource can now flattr autosubmit URLs, you will need to url
encode the data you pass into the `url` parameter. This means if you
pass another users `user_id` a new thing will be created with the
`user_id` as owner and the current user will flattr the new thing.
If you specify the current users username as `user_id` the thing will be
created but the current user cant flattr the new thing since you can't
flattr your own things. For more information check out the [auto submit documentation](/auto_submit).

##### Request
```
POST <%=@config[:api_url]%>/flattr
```
<%= json({:url => "http://flattr.com/submit/auto?url=http://blog.flattr.net/2011/10/api-v2-beta-out-whats-changed/",:user_id => "flattr"}) %>

##### Example response to autosubmit URL

<%= headers(200) %>
<%= json(:flattr_create) %>
