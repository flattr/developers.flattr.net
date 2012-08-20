---
title: Flattr in feeds and HTML
---
### Introduction

If you want to make Flattr discoverable in your RSS or Atom feeds or in your HTML then this is the recommended way for doing so.

Making Flattr discoverable in a feed is useful for eg. podcatchers and in HTML it is useful for eg. browser extensions. The method described in here is not limited to feeds and HTML - it can often be used in other formats as well.

### Shorter version

You include Flattr in your feeds and HTML by adding payment links, using the standard *payment* relation, to your feed, feed entries or HTML-head that you point directly to (*without any redirects*) the [auto-submit URL:s](/auto-submit/) for that content.

#### Example

In an **Atom feed** add something like this to an entry:

```xml
<link rel="payment" href="https://flattr.com/submit/auto?url=https%3A%2F%2Fdevelopers.flattr.net%2F&amp;user_id=flattr" type="text/html" />
```

In an item in a **RSS feed** add this instead:

```xml
<atom:link rel="payment" href="https://flattr.com/submit/auto?url=https%3A%2F%2Fdevelopers.flattr.net%2F&amp;user_id=flattr" type="text/html" />
```

And in a **RSS feed** also make sure that the RSS-container itself knows of the atom:link-tag by adding the atom-namespace:

```xml
<rss xmlns:atom="http://www.w3.org/2005/Atom">
```

In **HTML** add something like this to the head-tag of the document:

```html
<link rel="payment" href="https://flattr.com/submit/auto?url=https%3A%2F%2Fdevelopers.flattr.net%2F&amp;user_id=flattr" type="text/html" />
```

### Client support

* [Podkicker Pro Podcast Player](https://play.google.com/store/apps/details?id=com.podkicker) (Support for feeds)
* [Flattr Chrome Extension](https://chrome.google.com/webstore/detail/opjnhfkbdoopgfbefgbdkpjnbghffmln) (Support for HTML)
* [Flattr Firefox Add-on](https://addons.mozilla.org/firefox/addon/flattr/) (Support for HTML)
* [gPodder](http://gpodder.org/) (Support for feeds)

### Provider support

* [WordPress Flattr plugin](http://wordpress.org/extend/plugins/flattr/) (Support for feeds and HTML)

### Longer version

What is this standard payment relation that we suggest you to use? It's the one defined in the "Web Linking" standard [RFC5988](http://tools.ietf.org/html/rfc5988#page-14) and fits the use case perfectly, being defined as usable for eg. tipjars.

The "[Web Linking](http://tools.ietf.org/html/rfc5988)" standard defines a common link relations registry for Atom-feeds, HTML-documents, HTTP Link-headers etc. - thus this method isn't strictly limited to feeds, but feeds are the primary use case that we see.

With [auto-submit URL:s](/auto-submit/) as payment-links all clients already supporting payment-relations will automatically support Flattr links, but clients that wants to do Flattr specific integrations can also do so.

Eg. mobile clients that wants a better UX-flow for Flattr can implement such by checking payment-links for URL:s matching the pattern of [auto-submit URL:s](/auto-submit/) (links starting with "https://flattr.com/submit/auto") and use those URL:s for the API resources [/things/lookup](/api/resources/things/#check-if-a-thing-exists) and [/flattr](/api/resources/flattrs/#flattr-a-autosubmit-url) to get more info about them or to flattr them.

We discourage hiding [auto-submit URL:s](/auto-submit/) behind redirects – clients should be able to expect that a Flattr payment link is identifiable by just matching it against a pattern.
