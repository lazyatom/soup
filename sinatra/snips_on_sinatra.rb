require 'rubygems'
require 'sinatra'

$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

require 'erb'
include ERB::Util

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

def renderer(params)
  Render::Base.new(params)
end

def edit(snip_name)
  @snip = Snip[snip_name]
  erb renderer(params).render_part_as_snip(SystemSnip, :edit_template)
end

def raw(snip_name)
  @snip = Snip[snip_name]
  renderer(params).render(snip_name)
end

def show(snip_name)
  @snip = Snip[snip_name]
  Render::Erb.new(params).render(SystemSnip, :main_template)
end

SystemSnip = Snip['system']

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
  renderer(params).render(params[:snip], params[:part])
end

get '/edit/:snip' do 
  edit params[:snip]
end

