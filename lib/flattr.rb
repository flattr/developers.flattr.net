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
        401 => '401 Unauthorized',
        403 => '403 Forbidden',
        404 => '404 Not Found',
        409 => '409 Conflict',
        422 => '422 Unprocessable Entity',
        500 => '500 Server Error'
      }

      def headers(status, headers = {}, contentType = "")
        css_class = "headers"
        lines = ["Status: #{STATUSES[status]}"]
        if contentType != ""
          lines << contentType
        else
          lines << "Content-type: application/json;charset=utf-8"
        end
        headers.each do |key, value|
          lines << "#{key}: #{value}"
        end
        lines << "X-RateLimit-Limit: 5000"
        lines << "X-RateLimit-Remaining: 4999"

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

      THING_FULL = THING_PUBLIC.merge({
        "last_flattr_at" => 1320262599,
        "updated_at" => 0,
        "flattrs_current_period" => 0,
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
          "resource" => "https://api.flattr.local/rest/v2/things/313733",
          "link" => "https://flattr.local/things/313733",
          "id" => 313733,
          "url" => "https://flattr.com/profile/gnuproject",
          "title" => "GNU's not Unix!",
          "owner" => {
            "type" => "user",
            "resource" => "https://api.flattr.local/rest/v2/users/gnuproject",
            "link" => "https://flattr.local/user/gnuproject",
            "username" => "gnuproject"
          }
        },
        "owner" => {
          "type" => "user",
          "resource" => "https://api.flattr.local/rest/v2/users/qzio",
          "link" => "https://flattr.local/user/qzio",
          "username" => "qzio"
        },
        "created_at" => 1316697578
      }

      FLATTR_CREATE = {
        "message" => "ok",
        "description" => "Thing was successfully flattred",
        "location" => "https://api.flattr.com/rest/v2/things/423405"
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
        "city" => "",
        "zip" => "",
        "province" => "",
        "cellphone" => "",
        "avatar" => "",
        "about" => "This is the official Flattr account. We made this site :)",
        "country" => ""
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
