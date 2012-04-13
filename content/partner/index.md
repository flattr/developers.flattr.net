---
title: Partner Site Integration
---

If you are Flattr partner and you have received a partner key you can use this documentation..

To apply for partnership please get in [contact](https://flattr.com/support/contact) with us.

### Community partner buttons

#### Introduction

The community partner buttons mechanism is a way for communities to add Flattr buttons to all their users' content without the user having to preregister at Flattr to get them.

The mechanism uses non-flattr user identifiers to identify ownership of the things and lets the user claim its things and flattrs by later confirming that its the rightful owner of that identifier.

Callbacks are supported for notifying partner sites when something happens to one of their unclaimed things - such as them receiving flattrs. That way partners can communicate what is happening to their users so that their users are aware that they have money to claim.

#### Steps

1. Auto-submit / Embedded buttons
2. Web Hook callbacks

#### Auto-submit / Embedded buttons

The first step is to add a way for users to be able to flattr the content on the site. There's two ways to do this.

The best user experience is achieved by using our javascript based embedded buttons which embeds buttons as iframes through which logged in users can flattr right away.

If for any reason embedded buttons won't work one can instead use our static auto-submit to open a page on Flattr.com for the thing on which it can be flattred.

Through the auto-submit process (auto-submitting means that a Flattr thing is created automatically when the first flattr is made - they don't have to be presubmitted) the description of the thing is currently also added - the name, category, language etc.

__However__ - we're looking at moving away from auto-submit provided description data in the _future_ and fetch the description of the thing from its URL instead - using [Open Graph](http://ogp.me/) data or similar. Would be nice if partners kept this in mind when choosing URL:s for their things. Feedback is also welcome.

#### Embedded buttons

[Embedded buttons](/button) for community partners work the same way as a normal [auto-submitting](/auto-submit) Flattr button.

The difference between normal buttons and the ones used by community partners is that community partners assigns an `owner` parameter instead of the `uid` parameter used by ordinary buttons. The owner parameter contains an identifier for a non-flattr user. See a list of supported identifiers in the section _"Supported user identifiers"_ at the end of this document.

#### Static auto-submit

The static auto-submit is a link that redirects to either an existing thing or to a temporary page where the thing can be flattred and thus also created through the auto-submit.

The basic URL for the static auto-submit is `https://flattr.com/submit/auto` and to that a bunch of query parameters are added of which two are critical for community partners: The `url` and `owner` parameters. The auto-submit parameters for the thing description like `title` and `decription` are the same as for the button. See [embedded button documentation](/button) for a full list.

#### Example: Auto-submit a URL

`https://flattr.com/submit/auto?url=http://example.com/&owner=twitter:user:id:123&title=Example`

### Web Hook callbacks

For partners to get notified when something happens to their site's unclaimed things we have added support for web hooks - this means that partners can pass the notification on to the owner of thing so that partners can be sure that the user knows about it.

A single web hook URL is registered with us and which events that should be sent to it. Whenever an event occurs we then do a POST-request to that URL with a form encoded body containing event specific parameters as well as a `_event` parameter indicating the type of event. Partner sites should always check the `_event` parameter prior to processing an event to be sure that they are processing the right event.

### Supported events

#### Unclaimed thing receives a pending flattr

__Event name:__ `pendingclickcreate`

__Parameters:__

* __thing\_id__ - The numeric id of the thing that was clicked
* __thing\_owner\_id__ - The full user identifier specified for the thing - will likely be the one specified by the partner in in Step 1.
* __thing\_clicks\_total__ - The total amount of clicks after this click happened. (While hooks are likely to be executed in order - don't count on it)
* __flattrer\_username__ - The username of the user that did the flattr - or empty if the user flattrs anonymously
* __claim\_url__ - URL to a page on Flattr.com where the user can claim their things. If the owner was specified as an e-mail address then append the unhashed e-mail address to the claim url like "/owner/foo%40example.com".

### Partner requirements

Community partner functionality is, due to its implementation, currently limited to selected partners. Partner registration is required for non-flattr user identifiers as well as callbacks to work. Please contact the Flattr team to get registered as a partner.

### Supported user identifiers

* E-mail addresses, MD5 hashed. Eg: `email:05f8b3480b04f6a516bb1a46e556323c`
* Twitter user ids. Eg. `twitter:user:id:123`
* Partner ids. Eg. `partner:namespace:123`

### Verifying custom identifiers

If we have arranged it so that you can verify that a given Flattr account is owned by a user on your system, you can use a simple API call to associate the two accounts. This will make all pending things associated with the user on your system to automatically be claimed by the Flattr account.

##### Parameters

- **identity** - The URI that you want to associate with the Flattr account, e.g. "partner:namespace:123" where "123" is e.g. the ID number of a user on your system. Contact us if you do not know what your partner namespace is.

##### Request
```
POST <%= @config[:api_url]%>/users/:username/verify
```

##### Verify an authenticated user
```
POST <%= @config[:api_url]%>/user/verify
```

##### Example response

<%= headers(200) %>

##### Errors

* `unauthorized`  (401 Unauthorized) - You are either not logged in, are providing an invalid identifier, or are not allowed to verify the provided identifier.
