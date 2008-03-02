require 'rubygems'
require 'sinatra'

$LOAD_PATH << "lib"
$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH.uniq!

require 'soup'
require 'render'
require 'dynasnip'

require 'erb'
include ERB::Util

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'soup_development.db'
)

Sinatra::StaticEvent::MIME_TYPES.merge!({'' => 'text/plain'})
Sinatra::StaticEvent::MIME_TYPES.merge!({'js' => 'text/javascript'})

module Router
  def link_to(snip_name, part=nil)
    %{<a href="#{Router.url_to(snip_name, part)}">#{snip_name}</a>}
  end
  
  def url_to(snip_name, part=nil)
    url = "/#{snip_name}"
    url += "/#{part}" if part
    url
  end

  def url_to_raw(snip_name, part=nil)
    url = "/#{snip_name}"
    url += "/#{part}" if part
    url += ".raw"
  end
  
  def edit_link(snip_name, link_text)
    %[<a href="/edit?snip_to_edit=#{snip_name}">#{link_text}</a>]
  end
  
  def new_link(snip_name="New")
    %[<a href="/new" class="new">#{snip_name}</a>]
  end
  
  extend self
end

helpers do
  def present(snip_name, part=nil)
    case params[:format]
    when 'html'
      # render in main template
      Render.render('system', :main_template, [], params, Render::Erb)
    when 'raw'
      # Return the raw content of the snip (or snip part)
      Render.render(snip_name, part || :content, [], params, Render::Raw)
    when 'text'
      # Render the content of this snip, but without recursing into other snips
      Render.render_without_including_snips(snip_name, part || :content, [], params)
    else
      "Unknown format '#{params[:format]}'"
    end
  end  
end

static('/public', 'vanilla/public')

get('/') { redirect Router.url_to('start') }
get('/:snip') { present params[:snip] }
get('/:snip/:part') { present params[:snip], params[:part] }
