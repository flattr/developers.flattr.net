---
title: Flattr in feeds
---
### Introduction

If you want to include Flattr in your RSS or Atom feeds then this is the recommended way for doing so. Including Flattr in a feed can be useful for podcasts and similar but the same method can also be used in other scenarios.

### Shorter version

You include Flattr in your feeds by adding payment links, using the standard *payment* relation, to your feed entries that you point directly to (*without any redirects*) [auto-submit URL:s](/auto-submit/) for those feed entries.

#### Example

In an Atom feed add something like this to an entry:

```xml
<link rel="payment" href="https://flattr.com/submit/auto?url=https%3A%2F%2Fdevelopers.flattr.net%2F&amp;user_id=flattr" type="text/html" />
```

In an item in a RSS feed add this instead:

```xml
<atom:link rel="payment" href="https://flattr.com/submit/auto?url=https%3A%2F%2Fdevelopers.flattr.net%2F&amp;user_id=flattr" type="text/html" />
```

And in a RSS feed also make sure that the RSS-container itself knows of the atom:link-tag by adding the atom-namespace:

```xml
<rss xmlns:atom="http://www.w3.org/2005/Atom">
```

### Client support

* [Podkicker Pro Podcast Player](https://play.google.com/store/apps/details?id=com.podkicker)

### Provider support

* [WordPress Flattr plugin](http://wordpress.org/extend/plugins/flattr/)

### Longer version

What is this standard payment relation that we suggest you to use? It's the one defined in the "Web Linking" standard [RFC5988](http://tools.ietf.org/html/rfc5988#page-14) and fits the use case perfectly, being defined as usable for eg. tipjars.

The "[Web Linking](http://tools.ietf.org/html/rfc5988)" standard defines a common link relations registry for Atom-feeds, HTML-documents, HTTP Link-headers etc. - thus this method isn't strictly limited to feeds, but feeds are the primary use case that we see.

With [auto-submit URL:s](/auto-submit/) as payment-links all clients already supporting payment-relations will automatically support Flattr links, but clients that wants to do Flattr specific integrations can also do so.

Eg. mobile clients that wants a better UX-flow for Flattr can implement such by checking payment-links for URL:s matching the pattern of [auto-submit URL:s](/auto-submit/) (links starting with "https://flattr.com/submit/auto") and use those URL:s for the API resources [/things/lookup](/api/resources/things/#check-if-a-thing-exists) and [/flattr](/api/resources/flattrs/#flattr-a-autosubmit-url) to get more info about them or to flattr them.

We discourage hiding [auto-submit URL:s](/auto-submit/) behind redirects – clients should be able to expect that a Flattr payment link is identifiable by just matching it against a pattern.
