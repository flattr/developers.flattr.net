---
title: Flattrs
---

#### The Flattr object
<%= response_fields(:flattr) %>

#### List a users flattrs

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive ( default: 30 )
- **page** ( _Optional_ ) - Page of results to retreive (first page is 1)
- **full** ( _Optional_ ) - Receive full thing and user objects instead of small

##### Request
```
GET <%= @config[:api_url]%>/users/:username/flattrs
```

##### Example response
<%= headers(200) %>
<%= json(:flattr) {|t| [t]} %>

If the response header is `200 OK` but the response is empty there is two possible reasons. One is that the user have choosen to hide what he/she flattrs. The other is because that user haven't flattred anything yet.
##### Errors

* `not_found` (404 Not Found) - The requested user could not be found

####  List the authenticated users flattrs

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive
- **page** ( _Optional_ ) - Page of results to retreive
- **full** ( _Optional_ ) - Receive full thing and user objects instead of small

##### Request
```
GET <%= @config[:api_url]%>/user/flattrs
```

##### Example response
<%= headers(200) %>
<%= json(:flattr) {|t| [t]} %>

##### Errors

* `unauthorized ` (401 Unauthorized) - You are unauthorized to access the resource (no token?)

#### List a things flattrs

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive ( default: 30 )
- **page** ( _Optional_ ) - Page of results to retreive (first page is 1)
- **full** ( _Optional_ ) - Receive full thing and user objects instead of small

##### Request
```
GET <%= @config[:api_url]%>/things/:id/flattrs
```

##### Example response
<%= headers(200) %>
<%= json(:flattr) {|t| [t]} %>

##### Errors

* `unauthorized ` (401 Unauthorized) - You are unauthorized to access the resource (no token?)

#### Flattr a thing

**Scope required**: flattr

##### Request
```
POST <%= @config[:api_url] %>/things/:id/flattr
```

##### Example response
<%= headers(200) %>
<%= json(:flattr_create) %>

##### Errors

* `flattr_once` (HTTP 403) - The current user have already flattred
  the thing
* `flattr_owner` (HTTP 403) - User is the owner of the thing
* `no_means` (HTTP 401) - Current user don't have enough means to flattr
* `not_found` (HTTP 404) - Thing does not exist
* `invalid_request` (HTTP 400) - Request is not valid

#### Flattr a URL

**Scope required**: flattr

The flattr resource flattrs flattrable URL:s. Flattrable URL:s are those already registered with Flattr, those that we support discovering ownership data of and those contained within an [auto-submit URL](/auto-submit) together with the metadata needed to register a new thing.

##### Discoverable URL:s

We support discovering ownership data from these URL:s.

* **GitHub** profiles, repositories, commits and gists that isn't owned by an organization.
* **SoundCloud** profiles, tracks and sets.
* **Twitter** profiles and tweets.
* **Instagram** photos.

##### Auto-submit URL:s

An [auto-submit URL](/auto-submit) contains all necessary metadata for a thing. If the URL in an auto-submit URL isn't registered on Flattr, then it will be created before being then flattred. Auto-submit URL:s are recommended for use in eg. [feeds](/feed/) and looks like this: `http://flattr.com/submit/auto?url=http%3A%2F%2Fblog.flattr.net%2F2011%2F10%2Fapi-v2-beta-out-whats-changed%2F&user_id=flattr`.

##### Parameters

- **url** ( _Required_ ) - The URL to flattr or an [auto-submit URL](/auto-submit) containing the URL to flattr

##### Request
```
POST <%=@config[:api_url]%>/flattr
```
<%= json({:url => "http://flattr.com/submit/auto?url=http%3A%2F%2Fblog.flattr.net%2F2011%2F10%2Fapi-v2-beta-out-whats-changed%2F&user_id=flattr"}) %>

##### Example response to autosubmit URL

<%= headers(200) %>
<%= json(:flattr_create) %>

##### Errors

* `flattr_once` (HTTP 403) - The current user have already flattred
  the thing
* `flattr_owner` (HTTP 403) - User is the owner of the thing
* `no_means` (HTTP 401) - Current user don't have enough means to flattr
* `not_found` (HTTP 404) - Thing does not exist
* `invalid_request` (HTTP 400) - Request is not valid
