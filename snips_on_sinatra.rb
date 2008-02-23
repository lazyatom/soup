require 'rubygems'
require 'sinatra'

$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

module Router
  def link_to(snip_name, part=nil)
    %{<a href="#{Router.url_to(snip_name, part)}">#{snip_name}</a>}
  end
  
  def url_to(snip_name, part=nil)
    url = "/space/#{snip_name}"
    url += "/#{part}" if part
    url
  end
  
  def edit_link(snip_name, link_text)
    %[<a href="/edit/#{snip_name}">#{link_text}</a>]
  end
  
  def new_link(snip_name="New")
    %[<a href="/new/#{snip_name}" class="new">#{snip_name}</a>]
  end
  
  extend self
end

def edit(snip)
  @snip = snip
  erb SystemSnip.edit_template  
end

def raw(snip_name)
  $params = params # store this for the save dyna, basically. hacky. horrible.

  @snip = Snip.find_by_name(snip_name)
  Render::Base.new.render(snip_name)
end

def show(snip_name)
  @rendered_snip = raw(snip_name)
  erb SystemSnip.main_template
end

SystemSnip = Snip.find_by_name('system')

def basic_unsaved_snip(params={})
  Snip.new({:name => "", :content => "", :render_as => "Markdown"}.update(params))
end

get '/' do
  show 'start'
end  

get '/new/:snip' do
  edit basic_unsaved_snip(:name => params[:snip])
end

get '/space/:snip' do
  show params[:snip]
end

get '/raw/:snip' do
  raw params[:snip]
end

get '/space/:snip/:part' do
  Render::Base.new.render(params[:snip], params[:part])
end

get '/edit/:snip' do 
  edit Snip.find_by_name(params[:snip])
end

