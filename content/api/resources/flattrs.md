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

#### Flattr a URL

**Scope required**: flattr

The flattr resource can flattr URL:s. If the URL is an [auto-submit URL](/auto-submit) then the thing it's refering to is flattred instead and created if not existing.

##### Request
```
POST <%=@config[:api_url]%>/flattr
```
<%= json({:url => "http://flattr.com/submit/auto?url=http://blog.flattr.net/2011/10/api-v2-beta-out-whats-changed/"}) %>

##### Example response to autosubmit URL

<%= headers(200) %>
<%= json(:flattr_create) %>
