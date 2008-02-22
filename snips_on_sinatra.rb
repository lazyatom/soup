require 'rubygems'
require 'sinatra'

$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

def bootstrap_data
  DataMapper::Persistence.auto_migrate!
  load 'system_snips.rb'
  load 'test_snips.rb'
end

#bootstrap_data

def edit(snip)
  @snip = snip
  erb SystemSnip.edit_template  
end

def raw(snip_name)
  @snip = Snip.find_by_name(snip_name)
  Render::Base.new.render(snip_name)
end

def show(snip_name)
  @rendered_snip = raw(snip_name)
  erb SystemSnip.main_template
end

SystemSnip = Snip.find_by_name('system')

def basic_unsaved_snip
  snip = Snip.new
  snip.name = ""
  snip.content = ""
  snip.render_as = "Markdown"
  snip
end

get '/' do
  show 'start'
end  

get '/new' do
  edit basic_unsaved_snip
end

get '/space/:snip' do
  $params = params # store this for the save dyna, basically. hacky. horrible.
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