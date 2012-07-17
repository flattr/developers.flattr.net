---
title: Add rate limit resource
kind: article
created_at: 2012-07-17
---

Added a new resource where you can find out your current rate limit.

##### Example request
```
GET <%=@config[:api_url]%>/rate_limit
```

##### Example response
<%= headers(200, {}, {:rate_limit => false})%>
<%= json ({
  "hourly_limit" => 1000,
  "remaining_hits" => 986,
  "current_hits"=>14,
  "reset_time_in_seconds"=>1342521939,
  "reset_time"=>"Tue, 17 Jul 2012 10:45:39 +0000 GMT"
}) %>

There is also two new headers, `X-RateLimit-Current` and `X-RateLimit-Reset`, included when you request data from a rate limited resource.

`X-RateLimit-Limit` - Current rate limit.   
`X-RateLimit-Remaining` - Requests left during the current period.   
`X-RateLimit-Current` - Requests you have made during the current period.   
`X-RateLimit-Reset` - When your period ends you get new request. It's a unix timestamp.   

More information about rate limiting is available in the [documentation](/api/#rate-limiting).
