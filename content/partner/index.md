---
title: Partner site integration
---

This documentation is for Flattr Partners.

You can apply for partnership over at our [partnership site](https://partner.flattr.com).

### Revenue Sharing

To take part in revenue sharing with Flattr you need to generate a Revenue Sharing Key on our [partner site](https://partner.flattr.com). This key is unique and used to identify all the flattrs you make as a partner on Flattr.

#### Revenue Sharing with Embedded button/Auto-submit

If you use javascript buttons in your Flattr integration you need to add your revshare key ( available on
the [partner site](https://partner.flattr.com) to either the Flattr javascript or to a attribute on the
Flattr button.

**Example: Add revenue sharing key to the Flattr Javascript**

```javascript
<script type="text/javascript">
/* <![CDATA[ */
(function() {
    var s = document.createElement('script');
    var t = document.getElementsByTagName('script')[0];

    s.type = 'text/javascript';
    s.async = true;
    s.src = '//api.flattr.com/js/0.6/load.js'+
        '?mode=auto&revsharekey=YOUR_REVENUE_SHARING_KEY';

    t.parentNode.insertBefore(s, t);
 })();
/* ]]> */
</script>
```

**Example: Add the revenue sharing key as a data-flattr attribute on the link HTML tag**

```html
<a class="FlattrButton" style="display:none;"
    title="This is my title"
    data-flattr-uid="flattr"
    data-flattr-tags="text, opensource"
    data-flattr-category="text"
    data-flattr-revsharekey="YOUR_REVENUE_SHARING_KEY"
    href="http://wp.local/?p=444">

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Lorem ipsum dolor sit amet, consectetur adipiscing
    Maecenas aliquet aliquam leo quis fringilla.
</a>
```

#### REST API

If you are flattering through our REST API you need to make certain that your Revenue Sharing Key is connected to your Application on the [partner site](http://partner.flattr.com). If it is, you won't need to do anything futher.

### Partner namespaces

#### Introduction

Partner namespaces is a way for partners to create Things for their users' content without the user having to preregister at Flattr. When the user later on signs up for Flattr they will receive all the pending flattrs and gain ownership of all of their Things.

The mechanism uses non-flattr user identifiers to identify ownership of the things and lets the user claim it's things and flattrs by later confirming that its the rightful owner of that identifier.

Namespaces are created in dialog with Flattr, so [contact us](https://flattr.com/contact) and we can discuss futher.

Web Hook Callbacks are supported for notifying partners when something happens to one of their users unclaimed things - such as them receiving flattrs. That way partners can easily communicate what is happening on Flattr to their users and make them aware that they have flattrs to claim..

#### Auto-submit / Embedded buttons

The first step is to add a way for users to be able to flattr the content on your site.

The best user experience is achieved by using our javascript based [embedded buttons](/button) which embeds buttons as iframes through which logged in users can flattr right away.

If for any reason embedded buttons won't work one can instead use our static auto-submit to open a page on Flattr.com with the thing on which it can be flattred.

Through the auto-submit process (auto-submitting means that a Flattr thing is created automatically when the first flattr is made - they don't have to be presubmitted) the description of the thing is currently also added - the name, category, language etc.

__However__ - we're looking at moving away from auto-submit provided description data in the _future_ and fetch the description of the thing from its URL instead - using [Open Graph](http://ogp.me/) data or similar. Partners need to keep this in mind when choosing URL:s for their things. Feedback is also welcome.

##### Embedded Buttons

[Embedded buttons](/button) for partners work the same way as a normal Flattr button.

The difference between normal buttons and the ones used by partners is that a partner may assign an `owner` parameter instead of the `uid` parameter used by ordinary buttons. The owner parameter contains an identifier for a non-flattr user. See a list of supported identifiers in the section [Supported user identifiers](#supported-user-identifiers) at the end of this document.

##### Static Auto-submit

The static auto-submit is a link that redirects to either an existing thing or to a temporary page where the thing can be flattred and thus also created through the auto-submit.

The basic URL for the static auto-submit is `https://flattr.com/submit/auto` and to that a couple of query parameters are added see [embedded button documentation](/button).
As with the Embedded buttons, a partner may assign an `owner` instead of the `uid` parameter.

__Example Auto-submit URL__   

`https://flattr.com/submit/auto?url=http://example.com/&owner=twitter:user:id:123&title=Example`

#### Web Hook callbacks

For partners to get notified when something happens to their site's unclaimed things we have added support for web hooks - this means that partners can pass the notification on to the owner of thing so that partners can be sure that the user knows about it.

A single web hook URL is registered with us and which events that should be sent to it. Whenever an event occurs we do a POST-request to that URL with a form encoded body containing event specific parameters as well as a `_event` parameter indicating the type of event. Partner sites should always check the `_event` parameter prior to processing an event to be sure that they are processing the right event.

#### Available Web Hook Events

##### Unclaimed thing receives a pending flattr

__Event name:__ `pendingclickcreate`

__Parameters:__

* __thing\_id__ - The numeric id of the thing that was clicked
* __thing\_owner\_id__ - The full user identifier specified for the thing.
* __thing\_clicks\_total__ - The total amount of clicks after this click happened. (While hooks are likely to be executed in order - don't count on it)
* __flattrer\_username__ - The username of the user that did the flattr - or empty if the user flattrs anonymously
* __claim\_url__ - URL to a page on Flattr.com where the user can claim their things. If the owner was specified as an e-mail address then append the unhashed e-mail address to the claim url like "/owner/foo%40example.com".

#### Supported user identifiers

* E-mail addresses, MD5 hashed. Eg: `email:05f8b3480b04f6a516bb1a46e556323c`
* Twitter user ids. Eg. `twitter:user:id:123`
* Partner ids. Eg. `partner:customnamespace:123`

If you think a identifier is missing don't hesitate [contacting
us](https://flattr.com/contact) about it.

#### Verifying custom identifiers

If we have arranged it so that you can verify that a given Flattr account is owned by a user on your system, you can use a API call to associate the two accounts. This will make all pending things associated with the user on your system to automatically be claimed by the Flattr account.

##### Parameters

- **identity** - The URI that you want to associate with the Flattr account, e.g. `partner:customnamespace:123` where `123` is e.g. the ID number of a user on your system. Contact us if you do not know what your partner namespace is.

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
