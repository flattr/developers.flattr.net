---
title: REST API v2
subtitle: Documentation for the second iteration of our REST API
nav: main
nav_name: api
---

This API is newly released and is still in beta. We want your feedback on it to make sure we got everything right and may do some breaking changes where we realize we have made bad design decisions.

## Basics

- **API-endpoint**: <%= @config[:api_url] %>
- **OAuth 2 authorization**: <%= @config[:authorization_url] %>
- **OAuth 2 token**: <%= @config[:token_url] %>

All resource paths are relative to the API-endpoint.

### Rate limiting

Two headers regarding limit is sent in every response.

    X-RateLimit-Limit: 5000
    X-RateLimit-Remaining: 4999

X-RateLimit-Limit: is the current max requests.
X-RateLimit-Remaining is how many requests you have left until you are blocked temporary. When that happens, a *rate_limit_exceeded* error will be returned. Your remaining requests are reseted automatically every hour certain intervall.

## Authorization

To gain access to private data clients need to use [OAuth 2](http://tools.ietf.org/html/draft-ietf-oauth-v2-21). OAuth 2 is a standardized protocol for how to allow end users to authorize clients to gain access to their private data in the form of access tokens. OAuth 2 rely on separate standards for the access tokens - we currently use [Bearer tokens](http://tools.ietf.org/html/draft-ietf-oauth-v2-bearer-08) which are the simplest and most widespread token type.

To use OAuth 2 you need to [register their application](http://flattr.com/apps) and use the assigned Client ID and Client Secret. Client Secrets should be kept secret and not be revealed to anyone else than the application owner.

### Authenticate

To get a token you need to use the [authorization code flow](http://tools.ietf.org/html/draft-ietf-oauth-v2-21#section-4.1).

- **response_type** ( _Required_ ) - This can be set to `code` or `access_token`
- **client_id** ( _Required_ ) - The client_id found at http://flattr.com/apps
- **redirect_uri** ( _Optional_ ) -  The callback URL supplied when creating
  the application. It needs to be identical or else the authentication
  will fail.
- **scope** ( _Optional_ ) - [Available scopes](#scopes) Separate
  scopes with spaces.

(Extra line breaks are for display purposes only)

    GET <%= @config[:authorization_url] %>?response_type=code&
    client_id=1234&
    redirect_uri=http://localhost

If the end user authorize your application the user will be redirect to
your specified redirect\_uri which must be in the *callback_domain* you
specified when you registered your app at https://flattr.com/apps along
side with a parameter named `code` whom you can exchange for an
access token.

### Request an access token

To get hold of a access token you need to exchange your code for a
working token.

POST the `code` to the token endpoint and authorize using BASIC Auth
created from your `client_id` and `client_secret`
([ more information in RFC2617](http://tools.ietf.org/html/rfc2617))

- __code__ ( _Required_ ) - The `code` you received from authorization endpoint 
- __grant_type__ ( _Required_ ) - Set to `authorization\_code`
- __redirect_uri__ ( _Required_ ) - Your applications callback URL

**Access token request**

    POST <%= @config[:token_url] %>

    Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
    Content-Type: application/json

<%= json({
  :code => "un8Vzv7pNMXNuAQY3uRgjYfM4V3Feirz",
  :grant_type => "authorization_code",
  :redirect_uri => "http://localhost"
}) %>

    Content-Type: application/json; charset=utf-8
    Expires: Thu, 19 Nov 1981 08:52:00 GMT
    Cache-Control: no-store
    Pragma: no-cache

<%= json({
  :access_token => "8843d7f92416211de9ebb963ff4ce28125932878",
  :token_type => "bearer"
}) %>

Hurray! you now have an `access_token` whom you can use to access the
resources.


### Including token in request

Include the `access_token` in the header when accessing the resources to
authorize. More information is available in [oauth bearer token
draft](http://tools.ietf.org/html/draft-ietf-oauth-v2-bearer-08).

    Authorization: Bearer 8843d7f92416211de9ebb963ff4ce28125932878

## Scopes

##### Available scopes

- **flattr** - Flattr things
- **thing** - Create things
- **extendedread** - Read private user attributes and find hidden things

You can request several scopes when authorizing a user by separating
them with spaces ` `.

##### Example

```
GET <%= @config[:authorization_url] %>?response_type=code&
client_id=1234&
redirect_uri=http://localhost&
scope=flattr%20thing
```


## Response Formats

- **application/json** ( _Default_ )
- **text/xml**
- **application/yaml**

[Activity Streams](http://activitystrea.ms/) feeds are available for some resource, like **flattr**, **things** and **activities**.

- **application/stream+json** - defined in this [specification](http://activitystrea.ms/specs/json/1.0/)
- **application/atom+xml** - defined in this [specification](http://activitystrea.ms/specs/atom/1.0/)

Default response format is **application/json**.

You can specify another response format through the **Accept** header as
specified in
[rfc2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html) OR by
adding a suffix for the file format to the URL (ex. **categories.xml**).

When using POST, PATCH or PUT **application/json** and
**application/x-www-form-urlencoded** are valid formats.
