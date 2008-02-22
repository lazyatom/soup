require 'rubygems'
require 'sinatra'

$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

#DataMapper::Persistence.auto_migrate!
#load 'system_snips.rb'
#load 'test_snips.rb'

system_snip = Snip.find_by_name('system')

def basic_unsaved_snip
  snip = Snip.new
  snip.name = ""
  snip.content = ""
  snip.render_as = "Markdown"
  snip
end

get '/' do
  @snip_name = 'start'
  @snip = Snip.find_by_name(@snip_name)
  @rendered_snip = Render::Base.new.render(@snip_name)
  erb system_snip.main_template
end  

get '/new' do
  @snip = basic_unsaved_snip
  erb system_snip.edit_template
end

get '/:snip' do
  $params = params # store this for the save dyna, basically. hacky. horrible.
  @snip = Snip.find_by_name(params[:snip])
  @rendered_snip = Render::Base.new.render(params[:snip])
  erb system_snip.main_template
end

get '/:snip/edit' do 
  @snip = Snip.find_by_name(params[:snip])
  erb system_snip.edit_template
end

get '/:snip/:part' do
  Render::Base.new.render(params[:snip], params[:part])
end

