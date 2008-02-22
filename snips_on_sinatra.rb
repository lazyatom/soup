require 'rubygems'
require 'sinatra'

$LOAD_PATH << "lib"
$LOAD_PATH.uniq!

require 'soup'
require 'render'

DataMapper::Persistence.auto_migrate!

load 'system_snips.rb'
load 'test_snips.rb'

system_snip = Snip.find_by_name('system')

get '/' do
  @snip_name = 'start'
  @rendered_snip = Render::Base.new.render(@snip_name)
  erb system_snip.main_template
end  

get '/:snip' do
  @snip_name = params[:snip]
  @rendered_snip = Render::Base.new.render(@snip_name)
  erb system_snip.main_template
end

get '/:snip/edit' do
  @snip_name = params[:snip]
  @snip = Snip.find_by_name(@snip_name)
  erb system_snip.edit_template
end

get '/:snip/:part' do
  Render::Base.new.render(params[:snip], params[:part])
end

