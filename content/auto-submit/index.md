---
title: Auto-submit URL
---
Instead of the [embedded buttons](/button/) you can use a specific kind of URL that just like the button will autocreate, "auto-submit", a Flattr thing on its first flattr. This is useful for when you can't use javascript on a site (or don’t want to) – just create a static link to an auto-submit URL instead.

The URL format for submitting a thing is the following:
(newlines added for better visibility)

```
https://flattr.com/submit/auto?\
    user_id=[USERNAME]&url=[URL]&title=[TITLE]&\
    description=[DESCRIPTION]&language=[LANGUAGE]&\
    tags=[TAGS]&hidden=[HIDDEN]&category=[CATEGORY]
```

_Note_: The thing will submitted to our catalog when it’s flattred for the first time.

##### Parameters

* `user_id` (Required) - Your username on Flattr
* `url` (Required) - URL of the thing.
* `title` (Optional) - Title of your your thing.
* `description` (Optional) - Description for your thing.
* `language` (Optional) - Language of your page, use one of the [available languages](https://api.flattr.com/rest/v2/languages.txt).
* `tags` (Optional) - Tags you want your post to be tagged with. Multiple tags are separated with `,`
* `hidden` (Optional) - If you want to hide the things from public listings on flattr.com set `hidden` to `1`.
* `category` (Optional) - Category from the list of categories [found here](https://api.flattr.com/rest/v2/categories.txt).

### Linking
The URL you get from this can be linked in anyway you want, with text or image link.

If you want an image as a link you can use one of the available images.

#### Icon 16x16
![Flattr icon image](https://flattr.com/_img/icons/flattr_logo_16.png)  
__URL__: `https://flattr.com/_img/icons/flattr_logo_16.png`

#### Badge 93x20
![Flattr badge image](https://api.flattr.com/button/flattr-badge-large.png)  
__URL__: `https://api.flattr.com/button/flattr-badge-large.png`

#### Example

Create a 'Flattr API Documentation' thing. If it already exists a 'Flattr API Documentation' thing that thing will be displayed. If no thing exists we will _autosubmit_ the thing. When you get your first flattr we will create the thing. This means you won't be able to see all your autosubmitted things until they get their first flattr.

##### URL we are using

Line breaks are added for better visibility.

```
https://flattr.com/submit/auto?user_id=flattr&
  url=http://developers.flattr.net&
  title=Flattr%20API%20Documentation&
  description=Flattr%20API%20Documentation&
  language=en_GB&
  tags=flattr,api,programming&
  category=text
```

##### Link the badge to a thing

Line breaks are added for better visibility.

```html
<a href="https://flattr.com/submit/auto?
  user_id=flattr&url=http://developers.flattr.net&
  title=Flattr%20API%20Documentation&
  description=Flattr%20API%20Documentation&
  language=en_GB&tags=flattr,api,programming&category=text">

<img src="https://api.flattr.com/button/flattr-badge-large.png" 
  alt="Flattr our API Documentation" />
</a>
```

Result:

[![Flattr API Documentation](https://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=flattr&url=http://developers.flattr.net&title=Flattr%20API%20Documentation&description=Flattr%20API%20Documentation&language=en_GB&tags=flattr,api,programming&category=text)
