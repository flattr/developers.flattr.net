---
title: Languages
kind: api-resource
nav: api
---

#### List all available languages

##### Request
```
GET <%=@config[:api_url] %>/languages
```

##### Example response
<%=headers(200)%>
<%=json(:languages)%>

Note: The response have been shortened
