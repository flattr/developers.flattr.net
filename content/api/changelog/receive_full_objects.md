---
title: Receive full resources instead of small
kind: article
created_at: 2012-03-09
---

Now you can include a parameter called `full` in your request to certain resources
 and all objects inside the resource will always return all information available.

Example fetching a thing

##### Request without `full` parameter
```
GET <%=@config[:api_url]%>/things/450287
```

###### Response
<%=headers(200)%>
```javascript
{
  "id": 450287,
  "description": "A ruby gem wrapping Flattrs API.",
  "category": "software",
  "resource": "https://api.flattr.dev/rest/v2/things/450287",
  "flattrs": 9,
  "flattrs_user_count": 6,
  "created_at": 1323614098,
  "link": "https://flattr.dev/thing/450287",
  "tags": [
    "gem",
    "ruby",
    "programming",
    "opensource",
    "flattr",
    "api"
  ],
  "url": "https://github.com/simon/flattr",
  "type": "thing",
  "title": "Ruby gem wrapping Flattrs API",
  "owner": {
    "resource": "https://api.flattr.dev/rest/v2/users/smgt",
    "username": "smgt",
    "type": "user",
    "link": "https://flattr.dev/profile/smgt"
  },
  "image": "http://flattr.com/thing/image/4/5/0/2/8/7/medium.png",
  "language": "en_GB",
  "hidden": 0
}
```

The `owner` is just represented with `resource`, `username`, `type`
and `link`.

##### Request with the `full` parameter

```
GET <%=@config[:api_url]%>/things/450287?full
```

##### Response

```javascript
{
  "id": 450287,
  "description": "A ruby gem wrapping Flattrs API.",
  "category": "software",
  "resource": "https://api.flattr.dev/rest/v2/things/450287",
  "flattrs": 9,
  "flattrs_user_count": 6,
  "created_at": 1323614098,
  "link": "https://flattr.dev/thing/450287",
  "tags": [
    "gem",
    "ruby",
    "programming",
    "opensource",
    "flattr",
    "api"
  ],
  "url": "https://github.com/simon/flattr",
  "type": "thing",
  "title": "Ruby gem wrapping Flattrs API",
  "owner": {
    "avatar": "https://secure.gravatar.com/avatar/88bbe05fec72c1eba7c39d780c3bccae?s=48&r=pg",
    "city": "",
    "country": "Sweden",
    "resource": "https://api.flattr.dev/rest/v2/users/smgt",
    "firstname": "Simon",
    "lastname": "Gate",
    "username": "smgt",
    "link": "https://flattr.dev/profile/smgt",
    "type": "user",
    "about": "Human, programmer, climber, cyclist",
    "url": null
  },
  "image": "http://flattr.com/thing/image/4/5/0/2/8/7/medium.png",
  "language": "en_GB",
  "hidden": 0
}
```

As you can see the full `owner` object is included in the response.
