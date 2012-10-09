---
title: REST API v2
subtitle: Documentation for the second iteration of our REST API
---

This API is newly released and is still in beta. We want your feedback on it to make sure we got everything right and may do some breaking changes where we realize we have made bad design decisions.

## Basics

- **API-endpoint**: <%= @config[:api_url] %>
- **OAuth 2 authorization**: <%= @config[:authorization_url] %>
- **OAuth 2 token**: <%= @config[:token_url] %>

All resource paths are relative to the API-endpoint.

## Create a application

To use the API you need to [register a application](http://flattr.com/apps/new) and use the assigned Client ID and Client Secret. Client Secrets should be kept secret and not be revealed to anyone else than the application owner.

## Authorization

To gain access to private data we use [OAuth 2](http://tools.ietf.org/html/draft-ietf-oauth-v2-21) for authentication. OAuth 2 is a standardized protocol for how to allow end users to authorize clients to gain access to their private data in the form of access tokens. OAuth 2 rely on separate standards for the access tokens - we currently use [Bearer tokens](http://tools.ietf.org/html/draft-ietf-oauth-v2-bearer-08) which are the simplest and most widespread token type.

### Authenticate

To get a token you need to use the [authorization code flow](http://tools.ietf.org/html/draft-ietf-oauth-v2-21#section-4.1).

- **response_type** ( _Required_ ) - This can be set to `code` or `token`
- **client_id** ( _Required_ ) - The client id
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
specified when you registered your app at [https://flattr.com/apps/new](https://flattr.com/apps/new) along
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
- **thing** - Create, update and delete things
- **email** - Read the users email address
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

## Client errors

When a client side error occur you will get appropriete HTTP status
code and a body with information about the error.

* `invalid_request` (400 Bad Request) - Not a valid request
* `invalid_parameters` (400 Bad Request) - Parameter missing or invalid
* `unauthorized` (401 Unauthorized) - Unauthorized to access resource
* `rate_limit_exceeded` (403 Forbidden) - To many request the last hour
* `invalid_scope` (403 Forbidden) - Scope does not exist
* `insufficient_scope` (403 Forbidden) - Don't have the scope required to access resource
* `not_found` (404 Not Found) - Resource was not found
* `not_acceptable` (406 Not acceptable) - Unknown response format


##### Example request

```
GET <%= @config[:api_url] %>/things/nothing_here
```


##### Response

<%= headers(404)%>
<%= json ({
    "error"=>  "not_found",
    "error_description" =>  "The resource was not found",
    "error_uri" => "https://developers.flattr.net/api"
}) %>

## Response Formats

- **application/json** - .json ( _Default_ )
- **text/xml** - .xml
- **application/yaml** - .yaml

[Activity Streams](http://activitystrea.ms/) feeds are available for some resource, like **flattr**, **things** and **activities**.

- **application/stream+json** - .as - defined in this [specification](http://activitystrea.ms/specs/json/1.0/)
- **application/atom+xml** - .atom - defined in this [specification](http://activitystrea.ms/specs/atom/1.0/)

Default response format is **application/json**.

You can specify another response format through the **Accept** header as
specified in
[rfc2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html) OR by
adding a suffix for the file format to the URL (ex. **categories.xml**).

JSONP is supported by specifying a callback using the **jsonp** query parameter. The API also supports **CORS**, cross-origin resource sharing, for all requests – so JSONP [shouldn't be needed](http://caniuse.com/#search=cors) in most modern browsers.

When using POST, PATCH or PUT **application/json** and
**application/x-www-form-urlencoded** are valid formats of the request's own content.

### Rate limiting

Four headers regarding rate limit is sent in all responses where rate limit is applied.

    X-RateLimit-Limit: 1000
    X-RateLimit-Remaining: 999
    X-RateLimit-Current: 1
    X-RateLimit-Reset: 1342521939

`X-RateLimit-Limit` - Current rate limit.   
`X-RateLimit-Remaining` - Requests left during the current period.   
`X-RateLimit-Current` - Requests you have made during the current period.   
`X-RateLimit-Reset` - When your period ends you get new request. It's a unix timestamp.   

When you exceed your rate limit a `rate_limit_exceeded` error will be returned on all rate limited resources. Your requests are **reset every hour**.

There is also a resourse where you can check the current rate limit (this resource is not rate limited).

##### Example request

```
GET <%= @config[:api_url] %>/rate_limit
```


##### Response

<%= headers(200, {}, {:rate_limit => false})%>
<%= json ({
  "hourly_limit" => 1000,
  "remaining_hits" => 986,
  "current_hits"=>14,
  "reset_time_in_seconds"=>1342521939,
  "reset_time"=>"Tue, 17 Jul 2012 10:45:39 +0000 GMT"
}) %>
