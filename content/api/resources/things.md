---
title: Things
---

#### List a users things

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive ( default: 30 )
- **page** ( _Optional_ ) - Page of results to retreive ( first page is 1 )

##### Request
```
GET <%= @config[:api_url]%>/users/:username/things
```

##### Example response

<%= headers(200) %>
<%= json(:thing) %>

#### List a authenticated users things

*[Authorization](/api/#authorization) needed*

##### Parameters

- **count** ( _Optional_ ) - Number of records to receive ( default: 30)
- **page** ( _Optional_ ) - Page of results to retreive ( first page is 1 )

##### Request
```
GET <%=@config[:api_url]%>/user/things
```

##### Example response
<%= headers(200) %>
<%= json(:thing) {|t| [t]} %>

#### Get a thing

##### Request
```
GET <%=@config[:api_url]%>/things/:id
```

##### Example response without an access token (public)
<%= headers(200)%>
<%= json(:thing_public)%>


##### Example response when resource owner don't own the thing
<%= headers(200)%>
<%= json(:thing)%>

##### Example response when resource owner owns the thing
<%=headers(200)%>
<%=json(:thing_full)%>

#### Get multiple things

##### Parameters

- **id** ( _Optional_ ) - A list of thing ids you want separated with a
  comma (`,`).

##### Request
```
GET <%=@config[:api_url]%>/things/:id,:id
```

##### Example response
<%= headers(200)%>
<%= json(:thing_many) %>

#### Check if a thing exists

##### Parameters

- **url** (Optional) - The URL you want to lookup

##### Request
```
GET <%= @config[:api_url] %>/things/lookup/?url=:url
```

##### Example response when url was found
<%= headers(302, :Location => @config[:api_url]+"/things/423405") %>
<%= json(:thing_lookup) %>

##### Example response when url was not found
<%= headers(404) %>
<%= json(:thing_lookup_error) %>

##### Example request to lookup a autosubmit URL

The lookup resource can now lookup autosubmit URLs, you will need to url
encode the data you pass into the `url` parameter. For more information
check out the [auto submit documentation](/auto-submit).

```
GET <%=@config[:api_url]%>/things/lookup/?url=http://flattr.com/submit/auto?url=http://blog.flattr.net/2011/10/api-v2-beta-out-whats-changed/&user_id=flattr
```

##### Example response to autosubmit URL

<%= headers(302, :Location => @config[:api_url]+"/things/423405") %>
<%= json(:thing_lookup) %>

#### Create a thing

*[Authorization](/api/#authorization) needed*

**Scope required**: thing

**Parameters**

- **url** ( _Required_ ) - string URL to submit.
- **title** ( _Optional_ ) - string Title of the new thing.
- **description** ( _Optional_ ) - string Description text of the new thing.
- **category** ( _Optional_ ) - string Default is "**rest**"
- **language** ( _Optional_ ) - string Default is "**en_GB**"
- **tags** ( _Optional_ ) - string Comma separated list of tags.
- **hidden** ( _Optional_ ) - boolean  Default is "**false**"

##### Request
```
POST <%= @config[:api_url]%>/things
```

##### Request body
<%=json({:url => "http://developers.flattr.net"}) %>

##### Example response
<%=headers(201) %>
<%=json(:thing_create) %>

#### Update a thing

**Currently we are having problems with the PATCH request.**
To work around this problem you should do a POST request instead of an
PATCH and include the parameter ``_method`` with with the value
``patch``.

*[Authorization](/api/#authorization) needed*

**Scope required**: thing

**Parameters**

- **title** ( _Optional_ ) - string Title of the new thing.
- **description** ( _Optional_ ) - string Description text of the new thing.
- **category** ( _Optional_ ) - string
- **language** ( _Optional_ ) - string
- **tags** ( _Optional_ ) - string Comma separated list of tags.
- **hidden** ( _Optional_ ) - boolean 
- **\_method** ( _Required_ ) - must be set to **patch**

##### Request
```
PATCH <%= @config[:api_url] %>/things/:id
```

##### Request body
<%= json({:title => "API v2 documentation"}) %>

##### Example response
<%= headers(200) %>
<%= json(:thing_update) %>

#### Delete a thing

*[Authorization](/api/#authorization) needed*

**Scope required**: thing

##### Request
```
DELETE <%= @config[:api_url]%>/things/:id
```

##### Example response
<%= headers(204) %>
<pre class="highlight"><code></code></pre>

#### Errors

* `forbidden` (403 Forbidden) - Cannot delete thing

#### Search things

##### Parameters

- **query** (_Optional_) - string Free text search string
- **url** (_Optional_) - string Filter by url
- **tags** (_Optional_) - string Filter by tags, see syntax below
- **language** (_Optional_) - string Filter by language
- **category** (_Optional_) - string Filter by category
- **user** (_Optional_) - string Filter by username
- **sort** (_Optional_) - string Sort by `trend`, `flattrs` (all time),
  `flattrs_month`, `flattrs_week`, `flattrs_day` or
  `relevance` (default)
- **page** (_Optional_) - integer The result page to show
- **count** (_Optional_) - integer Number of items per page

##### Tags

Tags support a syntax to do advanced tag lookups. It supports `|` ( OR
), `!` ( NOT ) and `&` ( AND ). 

**Example:** Search all things containing the tag `game` or `games` but not
`software` would yield `game | games ! software`.

**Example:** Search all things containing the tags `photo` and `flickr` but
not any illustrations. `photo & flickr ! illustrations`

Remember to URL encode the tags or else you might be getting problems
with the ampersand `&`. For example `photos & travel & iphone !flickr`
would convert to `photos+%26+travel+%26+iphone+!flickr`.

##### Request
```
GET <%= @config[:api_url]%>/things/search
```

##### Example request
Search after `flattr` in the `software` category with the `ruby` tag

```
GET <%= @config[:api_url]%>/things/search?query=flattr&category=software&tags=ruby
```

##### Example response
<%= headers(200) %>
<%= json(:search) %>
