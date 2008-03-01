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
  :database => 'soup_development'
)

module Router
  def link_to(snip_name, part=nil)
    %{<a href="#{Router.url_to(snip_name, part)}">#{snip_name}</a>}
  end
  
  def url_to(snip_name, part=nil)
    url = "/space/#{snip_name}"
    url += "/#{part}" if part
    url
  end

  def url_to_raw(snip_name, part=nil)
    url = "/raw/#{snip_name}"
    url += "/#{part}" if part
    url
  end
  
  def edit_link(snip_name, link_text)
    %[<a href="/space/edit?snip_to_edit=#{snip_name}">#{link_text}</a>]
  end
  
  def new_link(snip_name="New")
    %[<a href="/space/new" class="new">#{snip_name}</a>]
  end
  
  extend self
end

helpers do
  # render in main template
  def show(snip_name)
    Render.render('system', :main_template, [], params, Render::Erb)
  end

  # Render the content of this snip, but without recursing into other snips
  def text(snip_name, part=nil)
    Render.render_without_including_snips(snip_name, part || :content, [], params)
  end

  # Return the raw content of the snip (or snip part)
  def raw(snip_name, part=nil)
    Render.render(snip_name, part || :content, [], params, Render::Raw)
  end  
end

get('/') { redirect Router.url_to('start') }

get('/space/:snip') { show params[:snip] }
get('/space/:snip/:part') { show params[:snip] }
   
get('/raw/:snip') { raw params[:snip] }
get('/raw/:snip/:part') { raw params[:snip], params[:part] }

get('/text/:snip') { text params[:snip]  }
get('/text/:snip/:part') { text params[:snip], params[:part] }


