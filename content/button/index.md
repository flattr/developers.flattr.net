---
title: Embedded buttons
nav: main
---
### Introduction

> Important: The target audience of this document is mainly site builders, web masters and developers. We assume that you at the very least have moderate knowledge of HTML.

The embedded button has two main uses. To load buttons for previously submitted things and to allow automatic submission (autosubmit from now on) of new things. The latter is very useful for web sites that may contain several pages, for example blogs.

There is two ways of defining a button in your code. One using HTML and another using JavaScript. Common for both of them is that the embedded button only has to be loaded once and that it is loaded asynchronously.

### The Loader

The first step of in using the embedded button is loading it. The url to the javascript is `http://api.flattr.com/js/0.6/load.js`. The embed script is loaded by placing the following call in the `<head>` tag of you HTML document:

```html
<script type="text/javascript">
/* <![CDATA[ */
(function() {
    var s = document.createElement('script');
    var t = document.getElementsByTagName('script')[0];

    s.type = 'text/javascript';
    s.async = true;
    s.src = 'http://api.flattr.com/js/0.6/load.js?mode=auto';

    t.parentNode.insertBefore(s, t);
 })();
/* ]]> */
</script>
```

A closer look at the url in the above example reveals that the url has a query string part to it. The embedded button loader supports adding optional parameters to the url which makes Flattr integration easier. In the above example we use the mode parameter to tell the loader to look for button definitions in the HTML source.

**Options**

For convenience we've also added a few query string parameters to set default parameters on all buttons.

* **mode** - auto | manual(default)
* **https** - 1 | 0 (defaults to the schema of load.js)
* **uid** - username
* **button** - compact | default
* **language** - can be set to any of the available languages
* **category** - Can be set to any of the available categories
* **html5-key-prefix** - a string that must start with 'data-'

The parameters `uid`, `button`, `language` and `category` can be used to set a default that will be used for your buttons unless they override the setting. The most useful of those being `uid`.

**Mode** is used to alter the way buttons are loaded. The default mode is `manual`, meaning that the user will have to initialize the API themselves through calling `setup()` (for more information see [manual mode](#manual-mode)). If the mode is set to `auto`, the embedded button script will search for button definitions in HTML as soon as the document is fully loaded (`onload`), removing the need to call `setup()`. This **mode** is the one used in the examples below, therefor we won't explain it further here.

As you've probably already figured out, the button can be loaded using HTTPS.
By default all buttons will be loaded with the same schema ( http or https ) as `load.js`.
In other words if you want to use HTTPS buttons then load `load.js` using HTTPS. If this doesn't work or you want to load the embedded button script using HTTP for whatever reason, you can set the query string parameter `https` to `1`.

In version 0.6 support for html5 custom data attributes was added. By default the embedded button script will look for data attributes starting with `data-flattr`. The parameter `html5-key-prefix` allows you to specify a custom prefix to use instead. Example: `&html5-key-prefix=data-fvar`

Note that the query string parameters are added to the `load.js` url and not to your individual buttons.

##### Example

```html
<script type="text/javascript">
/* <![CDATA[ */
    (function() {
        var s = document.createElement('script');
        var t = document.getElementsByTagName('script')[0];

        s.type = 'text/javascript';
        s.async = true;
        s.src = 'http://api.flattr.com/js/0.6/load.js?'+
                'mode=auto&uid=gargamel&language=sv_SE&category=text';

        t.parentNode.insertBefore(s, t);
    })();
/* ]]> */
</script>
```


Loading the script asynchronously is great but without adding buttons it's no fun, so lets move on...

### Adding buttons

A button is basically made up of a set of configuration instructions that tells the embedded button script how it should be display. There are a few different ways of defining the buttons, but the parameters required are common to them all.

The parameters are a set of key value pairs. Some of them are required, others are optional. The parameters are listed here in order of importance: 

* **url** ( Always required ) -  Each thing on Flattr requires a unique URL. All parts of the URL, including the both the parameters and fragments, are used to distinguish the difference between submitted URLs.

* **uid** ( Required when autosubmit, otherwise optional ) - A Flattr username. This is a required parameter for autosubmit but not for things that are already on flattr.com.

* **title** ( Required when autosubmit, otherwise optional ) - Will be used to describe your thing on Fattr. The `title` should be between 5-100 characters. All HTML is stripped.

* **description** ( Required when autosubmit, otherwise optional ) - Will be used to describe your thing. The `description` should be between 5-1000 characters. All HTML is stripped except the `<br\>` character which will be converted into newlines (`\n`).

* **category** ( Required when autosubmit, otherwise optional ) - This parameter is used to sort things on Flattr and has no impact on the functionality of your button. It's value must be one of the [available categories](https://api.flattr.com/rest/v2/categories.txt).

* **language** ( Optional ) - Specifies which language your thing is in. Specifying the language will allow visitors on Flattr to filter through the large amount of things and get a personalized feed of items in their selected languages. The value must be a language code from the [available languages](https://api.flattr.com/rest/v2/languages.txt). Note that even tho this parameter is optional, a language will be guessed and added automatically if it is omitted.

* **tags** ( Optional) - This parameter allows you to add tags that can be used to describe your thing. This is used on Flattr to allow further filtering and sorting of things. Multiple tags are seperated by a comma `,`. Using non alpha characters in tags are not supported nor is using a comma for obvious reasons.

* **button** ( Optional ) - We also provide a compact version of our Flattr button. This parameter tells the embedded button script which button layout to use. Set this parameter to `compact` if you want the compact button. Don't set the parameter at all if you are fine with the normal button.

* **hidden** ( Optional ) - Not all content is suitable for public listing. If you for one reason or another don't want your content to be listed on Flattr set this parameter to `1`.

### Defining the button with HTML

The easiest way of using the embedded button script is by defining buttons through HTML. The HTML definition is easy to add and requires no knowledge of JavaScript since it's syntax is made up of basic HTML code.

Adding, or as we say defining, a button is done like this.

```html
<a class="FlattrButton" href="[URL]" title="[title]" lang="[language]">
  [description]
</a>
```

Where the text within `[ ]` (square brackets) should be replaced by their actual values.

Note that the attributes on the anchor tag in the above example are basic HTML attributes. There are additional parameters that we need to define our buttons, but we can't just add them to the anchor tag because then the code would no longer be valid HTML. We solve this by placing our parameters inside the `rel` attribute.

The `rel` attribute value must begin with "flattr;", this is the flattr identifier telling our loader to look for parameters inside the attribute value. Parameters in the `rel` attribute are defined through key value pairs, using CSS syntax. Example: `language:en_GB;`

##### Example

```html
<a class="FlattrButton" style="display:none;"
    title="This is my title"
    rel="flattr;uid:mario;category:text;tags:tag,tag2,tag3;"
    href="http://wp.local/?p=444">

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Lorem ipsum dolor sit amet, consectetur adipiscing
    Maecenas aliquet aliquam leo quis fringilla.
</a>
```

#### HTML5

In HTML5 using the `rel` attribute is no longer possible. Instead we'll take advantage of a new feature in HTML5, custom data attributes. Unlike when using `rel` each parameter will be defined as a separate attribute where the attribute name is the parameter name prefixed with `data-flattr`. The attribute prefix can be changed using the query string parameter `html5-key-prefix`.

```html
<a class="FlattrButton" style="display:none;"
    title="This is my title"
    data-flattr-uid="flattr"
    data-flattr-tags="text, opensource"
    data-flattr-category="text"
    href="http://wp.local/?p=444">

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Lorem ipsum dolor sit amet, consectetur adipiscing
    Maecenas aliquet aliquam leo quis fringilla.
</a>
```

To avoid that the embedded button definition is shown while the page is loading we can either set the css class `FlattrButton` to be hidden in a stylesheet or add `style="display:none;"` to the a tag. In the example above we did the latter.

Note that you can add multiple buttons on your page. It's just a matter of adding another definition.

#### Manual mode

Manual mode is required when using JavaScript to define the buttons. But manual mode might also be useful in other cases. If you want to trigger the embedded button rendering manually all you need to do is call `FlattrLoader.setup()`.

##### Example

```html
<script type="text/javascript">
/* <![CDATA[ */
    window.onload = function(){

      doSomeCoolStuffBeforeWeLoadTheFlattrButtons();

        FlattrLoader.setup();
    }
/* ]]> */
</script>
```

#### Defining the button with JavaScript

Some people have more complex needs. We try to cater to developers using this alternative way of defining a Flattr button. Do not use this unless you are tech savvy and or comfortable with JavaScript.

Note that this will only work when the embedded button script is loaded in manual mode.

```html
<script type="text/javascript">
/* <![CDATA[ */
  window.onload = function() {
      FlattrLoader.render([button parameters], [target], [insert method]);
  };
/* ]]> */
</script>
```

The `[button parameters]` are defined as a javascript object where the object property is the key. See the parameter list in the section Adding buttons above for valid keys.
In addition to the before mentioned parameters you can also use these:

* **url** - URL to thing starting with `http://` or `https://`
* **title** - Title of thing
* **description** - Description for thing max 1000 characters, HTML will be stripped

Note that values should be escaped so that they don't break JS syntax.

Note that while `url`, `title` and `description` can also be used in the `rel` attribute (see [html definition](#defining-the-button-with-html) ), their intended and recommended use is for the javascript implementations.

`[target]` is either a DOM element or an ID of an tag. `[insert method]` is one of `append`, `before` or `replace`.

##### Example implementation

```html
<html>
<head>
<script type="text/javascript">
/* <![CDATA[ */
    window.onload = function() {
        FlattrLoader.render({
            'uid': 'flattr',
            'url': 'http://wp.local',
            'title': 'Title of the thing',
            'description': 'Description of the thing'
        }, 'element_id', 'replace');
    }
/* ]]> */
</script>
</head>

<body>
<div id="element_id"></div>
</body>
</html>
```


### Multiple onload events

If you have an advanced website chances are that you are already using a JavaScript that is triggered by the documents `onload` event.
In the examples above the examples adding the scripts to the `onload` event using
`window.onload`. The downside to this is that is can only keep one function at a time, so if I add two different functions to `onload` the latter overwrites the first.

If you are using [jQuery](http://jquery.com), [prototype](http://prototypejs.org/) or another javascript lib then you can use their event handlers to get around this. If not then `load.js` comes with it's own method. It is not as advanced as that of a full fledged javascript lib but it should get the job done for those of you with simpler needs.

The method is called `FlattrLoader.addLoadEvent()` and it takes one parameter, a function to be run `onload`.

```html
<script type="text/javascript">
/* <![CDATA[ */
    FlattrLoader.addLoadEvent(function() {
      alert('Hello world!');
    });
/* ]]> */
</script>
```
