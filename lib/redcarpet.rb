# encoding: utf-8

require 'redcarpet'
require "cgi"
require 'pygments.rb'

# create a custom renderer that allows highlighting of code blocks
class HTMLwithBlocks < Redcarpet::Render::HTML
  def block_code(code, language)
    if language.nil?
      '<pre class="highlight"><code>'+CGI.escapeHTML(code)+'</code></pre>'
    else
      code = Pygments.highlight(code, :lexer => language, :cssclass => "highlight")
    end
  end
  
  def header(text, header_level)
    if header_level < 5
      name = text.downcase.gsub(/\s/, "-").gsub(/![\-a-z]/, "")
      name = "id=\"#{name}\""
    end
    "<h#{header_level} #{name}>#{text}</h#{header_level}>"
  end
end

class Redcarpet2Filter < Nanoc3::Filter

  identifier :redcarpet2

  type :text

  def run(content, params={})
    options = params[:options] || []

    # renderer = Redcarpet::Renderer.new(
    #                 :with_toc_data => false,
    #                 :hard_wrap => false,
    #                 :xhtml => false
    #             )


    markdown = Redcarpet::Markdown.new(HTMLwithBlocks,
                :autolink => true,
                :space_after_headers => true,
                :tables => true,
                :fenced_code_blocks => true
               )

    return markdown.render(content)
  end
end

