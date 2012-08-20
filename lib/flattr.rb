require 'pp'
require 'yajl/json_gem'
require 'stringio'
require "pygments.rb"

module Flattr
  module Resources
    module Helpers

      STATUSES = {
        200 => '200 OK',
        201 => '201 Created',
        204 => '204 No Content',
        301 => '301 Moved Permanently',
        302 => '302 Found',
        304 => '304 Not Modified',
        400 => '400 Bad Request',
        401 => '401 Unauthorized',
        403 => '403 Forbidden',
        404 => '404 Not Found',
        409 => '409 Conflict',
        422 => '422 Unprocessable Entity',
        500 => '500 Server Error'
      }

      def headers(status, headers = {}, opts = {})

        css_class = "headers"

        default_opts = {
          :rate_limit => true
        }

        default_headers = {
          "Content-Type" => "application/json;charset=utf-8"
        }

        options = default_opts.merge(opts)
        headers = default_headers.merge(headers)

        lines = ["HTTP/1.1 #{STATUSES[status]}"]

        headers.each do |key, value|
          lines << "#{key}: #{value}"
        end

        if(options[:rate_limit])
          lines << "X-RateLimit-Limit: 1000"
          lines << "X-RateLimit-Remaining: 999"
          lines << "X-RateLimit-Current: 1"
          lines << "X-RateLimit-Reset: 1342521939"
        end

        %(<pre class="#{css_class}"><code>#{lines * "\n"}</code></pre>\n)
      end

      def json(key)
        hash = case key
          when Hash
            h = {}
            key.each { |k, v| h[k.to_s] = v }
            h
          when Array
            key
          else Resources.const_get(key.to_s.upcase)
        end

        hash = yield hash if block_given?
        Pygments.highlight(JSON.pretty_generate(hash), :lexer => "javascript")
        #"<pre><code class=\"language-javascript\">" + JSON.pretty_generate(hash) + "</code></pre>"
      end

      def response_fields(resource)
        resource = Resources.const_get("FIELDS_"+resource.to_s.upcase)
        html = "<p><table>\n"
        html << "<thead><tr><th>Field</th><th>Type</th><th>Permission</th><th>Description</th></tr></thead>\n"
        html << "<tbody>"
        resource.each do |field,data|
          html << "<tr><td class=\"mono\">#{field}</td><td class=\"mono\">#{data[:type].join(", ")}</td><td>#{data[:scope].join(", ")}</td><td>#{data[:description]}</td></tr>\n"
        end
        html << "</tbody></table></p>\n"
        html
      end

      FIELDS_FLATTR = {
        "type" => {
          :type => ['string'],
          :scope => [],
          :description => 'Object type, set to <code>flattr</code>.',
        },
        "thing" => {
          :type => ['hash'],
          :scope => [],
          :description => 'Contains a <a href="/api/resources/things/#the-thing-object">thing object</a>.',
        },
        "owner" => {
          :type => ['hash'],
          :scope => [],
          :description => 'Contains either a <a href="/api/resources/users/#the-user-object">user object</a> or a <a href="/api/resources/users/#the-mini-user-object">mini user object</a> (<strong>default</strong>).',
        },
        "created_at" => {
          :type => ["string"],
          :scope => [],
          :description => "Format is unixtime."
        }
      }


      FIELDS_USER = {
        "type" => {
          :type => ['string'],
          :scope => [],
          :description => 'Object type, set to <code>user</code>.',
        },
        "resource" => {
          :type => ['string'],
          :scope => [],
          :description => 'URL to the API resource',
        },
        "link" => {
          :type => ['string'],
          :scope => [],
          :description => 'URL to user on Flattr.com website',
        },
        "username" => {
          :type => ['string'],
          :scope => [],
          :description => 'Username on Flattr',
        },
        "url" => {
          :type => ['string'],
          :scope => [],
          :description => 'URL set by the user',
        },
        "firstname" => {
          :type => ['string'],
          :scope => [],
          :description => '',
        },
        "lastname" => {
          :type => ['string'],
          :scope => [],
          :description => '',
        },
        "avatar" => {
          :type => ['string'],
          :scope => [],
          :description => 'URL to a Flattr avatar, size: 48x48px',
        },
        "about" => {
          :type => ['string'],
          :scope => [],
          :description => 'Short description about the user',
        },
        "city" => {
          :type => ['string'],
          :scope => [],
          :description => '',
        },
        "country" => {
          :type => ['string'],
          :scope => [],
          :description => '',
        },
        "email" => {
          :type => ['string'],
          :scope => ['<a href="/api/#scopes">email</a>', '<a href="/api/#scopes">extendedread</a>'],
          :description => '',
        },
        "registered_at" => {
          :type => ['int'],
          :scope => ['<a href="/api/#scopes">extendedread</a>'],
          :description => 'Format is unixtime',
        }
      }

      FIELDS_MINI_USER = FIELDS_USER.keep_if{|k,v| %w{type resource link username}.include?(k) }

      FIELDS_THING = {
        'type' => {
          :type => ['string'],
          :scope => [],
          :description => 'Object type, set to <code>thing</code>.',
        },
        "resource" => {
          :type => ['string'],
          :scope => [],
          :description => 'URL to the API resource',
        },
        "link" => {
          :type => ['string'],
          :scope => [],
          :description => 'URL to user on Flattr.com website',
        },
        'id' => {
          :type => ['int'],
          :scope => [],
          :description => 'ID of the thing',
        },
        'url' => {
          :type => ['string'],
          :scope => [],
          :description => 'URL the thing is pointing to',
        },
        'flattrs' => {
          :type => ['int'],
          :scope => [],
          :description => 'Number of flattrs',
        },
        'flattrs_user_count' => {
          :type => ['int'],
          :scope => [],
          :description => 'Number of user who have flattred',
        },
        'title' => {
          :type => ['string'],
          :scope => [],
          :description => 'Title of the thing',
        },
        'description' => {
          :type => ['string'],
          :scope => [],
          :description => 'Description of the thing',
        },
        'tags' => {
          :type => ['array'],
          :scope => [],
          :description => 'Array with tags as strings',
        },
        'language' => {
          :type => ['string'],
          :scope => [],
          :description => '<a href="/api/resources/languages/">Langauge</a>',
        },
        'category' => {
          :type => ['string'],
          :scope => [],
          :description => '<a href="/api/resources/categories/">Category</a>',
        },
        'created_at' => {
          :type => ['int'],
          :scope => [],
          :description => 'Format is unixtime',
        },
        'owner' => {
          :type => ['array'],
          :scope => [],
          :description => 'User who owns the thing',
        },
        'hidden' => {
          :type => ['bool'],
          :scope => [],
          :description => 'Hidden or not in listings. Example, API search and Catalog.',
        },
        'image' => {
          :type => ['string'],
          :scope => [],
          :description => 'URL to thing image',
        },
        'owner' => {
          :type => ['hash'],
          :scope => [],
          :description => 'Contains either a <a href="/api/resources/users/#the-user-object">user object</a> or a <a href="/api/resources/users/#the-mini-user-object">mini user object</a> (<strong>default</strong>).',
        },
        'flattred' => {
          :type => ['bool'],
          :scope => ['<a href="/api/#authenticate">authenticated</a>'],
          :description => 'Has the authenticated user flattred the thing',
        },
        'last_flattr_at' => {
          :type => ['int'],
          :scope => ["owner"],
          :description => 'Last time flattred. Format is unixtime. Only available if the authenticated user owns the thing.',
        },
        'updated_at' => {
          :type => ['int'],
          :scope => ["owner"],
          :description => 'Last time updated. Format is unixtime. Only available if the authenticated user owns the thing.',
        }
      }

      FIELDS_MINI_THING = FIELDS_THING.keep_if{|k,v| %w{type resource link id url title image flattrs}.include?(k) }

      THING_PUBLIC = {
        "type" => "thing",
        "resource" => "https://api.flattr.com/rest/v2/things/423405",
        "link" => "https://flattr.com/thing/423405",
        "id" => 423405,
        "url" => "http://blog.flattr.net/2011/10/api-v2-beta-out-whats-changed/",
        "language" => "en_GB",
        "category" => "text",
        "owner" => {
          "type" => "user",
          "resource" => "https://api.flattr.com/rest/v2/users/flattr",
          "link" => "https://flattr.com/profile/flattr",
          "username" => "flattr"
        },
        "hidden" => false,
        "image" => "http://flattr.com/thing/image/4/2/3/4/0/5/medium.png",
        "created_at" => 1319704532,
        "tags" => [
          "api"
        ],
        "flattrs" => 8,
        "description" => "We have been working hard to deliver a great experience for developers and tried to build a good foundation for easily add new features. The API will remain in beta for a while for us to kill quirks and refine some of the resources, this means there might be big changes without notice for ...",
        "title" => "API v2 beta out - what's changed?"
      }

      THING_PUBLIC_2 = {
        "type" => "thing",
        "resource" => "https://api.flattr.dev/rest/v2/things/450287",
        "link" => "https://flattr.dev/thing/450287",
        "id" => 450287,
        "url" => "https://github.com/simon/flattr",
        "language" => "en_GB",
        "category" => "software",
        "owner" => {
          "type" => "user",
          "resource" => "https://api.flattr.dev/rest/v2/users/smgt",
          "link" => "https://flattr.dev/profile/smgt",
          "username" => "smgt"
        },
        "hidden" => 0,
        "image" => "",
        "created_at" => 1323614098,
        "tags" => [
          "gem",
          "ruby",
          "programming",
          "opensource",
          "flattr",
          "api"
        ],
        "flattrs" => 7,
        "description" => "A ruby gem wrapping Flattrs API.",
        "title" => "Ruby gem wrapping Flattrs API"
      }

      THING_MANY = [
        THING_PUBLIC,
        THING_PUBLIC_2
      ]

      THING_FULL = THING_PUBLIC.merge({
        "last_flattr_at" => 1320262599,
        "updated_at" => 0,
        "flattred" => false
      })

      THING =  THING_PUBLIC.merge({
        "flattred" => false
      })

      THING_LOOKUP = {
        "message" => "found",
        "location" => "https://api.flattr.com/rest/v2/things/423405"
      }

      THING_LOOKUP_ERROR = {
        "message" => "not_found",
        "description" => "No thing was found"
      }

      THING_CREATE = {
        "id" => 431547,
        "link" => "https://api.flattr.com/rest/v2/things/431547",
        "message" => "ok",
        "description" => "Thing was created successfully"
      }

      THING_UPDATE = {
        "message" => "ok",
        "description" => "Thing was updated correctly"
      }

      FLATTR = {
        "type" => "flattr",
        "thing" => {
          "type" => "thing",
          "resource" => "https://api.flattr.com/rest/v2/things/313733",
          "link" => "https://flattr.com/thing/313733",
          "id" => 313733,
          "url" => "https://flattr.com/profile/gnuproject",
          "title" => "GNU's not Unix!",
          "image" => "https://flattr.com/thing/image/3/1/3/7/3/3/medium.png",
          "flattrs" => 3,
          "owner" => {
            "type" => "user",
            "resource" => "https://api.flattr.com/rest/v2/users/gnuproject",
            "link" => "https://flattr.com/user/gnuproject",
            "username" => "gnuproject"
          }
        },
        "owner" => {
          "type" => "user",
          "resource" => "https://api.flattr.com/rest/v2/users/qzio",
          "link" => "https://flattr.com/user/qzio",
          "username" => "qzio"
        },
        "created_at" => 1316697578
      }

      FLATTR_CREATE = {
        "message" => "ok",
        "description" => "Thing was successfully flattred",
        "thing" => {
          "type" => "thing",
          "resource" => "https://api.flattr.dev/rest/v2/things/423405",
          "link" => "https://flattr.dev/thing/423405",
          "id" => 423405,
          "flattrs" => 3,
          "url" => "http://blog.flattr.net/2011/10/api-v2-beta-out-whats-changed/",
          "title" => "API v2 beta out - what's changed?",
          "image" => "https://flattr.com/thing/image/4/2/3/4/0/5/medium.png",
        }
      }

      ACTIVITIES =
      {
        "items" =>
        [
          {
            "published" => "2012-01-04T10:07:12+01:00",
            "title" => "pthulin flattred \"Acoustid\"",
            "actor" =>
            {
              "displayName" => "pthulin",
              "url" => "https:\/\/flattr.dev\/profile\/pthulin",
              "objectType" => "person"
            },
            "verb" => "like",
            "object" =>
            {
              "displayName" => "Acoustid",
              "url" => "https:\/\/flattr.dev\/thing\/459394\/Acoustid",
              "objectType" => "bookmark"
            },
            "id" => "tag:flattr.com,2012-01-04:pthulin\/flattr\/459394"
          }
        ]
      }

      LANGUAGES = [
        {
          "id" => "en_GB",
          "text" => "English"
        },
        {
          "id" => "sq_AL",
          "text" => "Albanian"
        },
        {
          "id" => "ar_DZ",
          "text" => "Arabic"
        },
        {
          "id" => "be_BY",
          "text" => "Belarusian"
        }
      ]

      CATEGORIES = [
          {
            "id" => "text",
            "name" => "Text"
          },
          {
            "id" => "images",
            "name" => "Images"
          },
          {
            "id" => "video",
            "name" => "Video"
          },
          {
            "id" => "audio",
            "name" => "Audio"
          },
          {
            "id" => "software",
            "name" => "Software"
          },
          {
            "id" => "people",
            "name" => "People"
          },
          {
            "id" => "rest",
            "name" => "Other"
          }
      ]

      USER = {
        "type" => "user",
        "resource" => "https://api.flattr.com/rest/v2/users/flattr",
        "link" => "https://flattr.com/profile/flattr",
        "username" => "flattr",
        "firstname" => "Flattr.com",
        "lastname" => "",
        "avatar" => "",
        "about" => "This is the official Flattr account. We made this site :)",
        "city" => "",
        "country" => "",
        "url" => "http://flattr.com"
      }

      USER_EXTENDED = USER.merge({
        "email" => "info@flattr.com",
        "registered_at" => 1270166816,
      })

      SEARCH = {
        "total_items" =>  1,
        "items" =>  1,
        "page" =>  1,
        "things" =>  [THING_PUBLIC]
      }

    end
  end
end

include Flattr::Resources::Helpers
