class AddTOC < Nanoc::Filter
  type :text
  identifier :add_toc

  def run(content, params={})
    require 'nokogiri'
    klass = ::Nokogiri::HTML

    add_toc(content, klass)
  end

  def add_toc(content, klass)
    links = []
    doc = content =~ /<html[\s>]/ ? klass.parse(content) : klass.fragment(content)
    doc.xpath('h4').each do |header|
      links << "<li><a href=\"##{header["id"]}\">#{header.content}</a></li>"
    end
    "<div id=\"toc\"><h5>Table of contents</h5>\n<ul>\n#{links.join("\n")}</ul></div>\n" + content
  end
end
