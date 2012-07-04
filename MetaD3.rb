#/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'haml'
require 'coffee-script'
require 'active_record'
require 'sqlite3'
require_relative 'lib/database'

set :port, 5786
set :environment, :production

before do 
  db = Database.new
end

#######################################################
### main sites
#######################################################

get( '/') { redirect '/simulator' }
get( '/simulator') { haml :'simulator/simulator' }
get( '/coffee/simulator') {
  content_type "text/javascript" 
  coffee(:"simulator/coffee/preDefs") +
  coffee(:"simulator/coffee/Enemy") +
  coffee(:"simulator/coffee/Player") +
  coffee(:"simulator/coffee/Calc") +
  coffee(:"simulator/coffee/Validator") +
  coffee(:"simulator/coffee/Widgets") +
  coffee(:"simulator/coffee/Simulation") +
  coffee(:"simulator/coffee/Storage") +
  coffee(:"simulator/coffee/main") 
}

# blocking requests until all done
=begin

#######################################################
### articles
#######################################################
get( '/guides/:id') {@guide = Guide.find params[:id].to_i; haml :'guides/show'}

#######################################################
### administration
#######################################################
get( '/admin') { haml :'admin/index' }

get( '/admin/categories') { @categories = Category.all; haml :'admin/categories/index'}
get( '/admin/categories/new') { haml :'admin/categories/new'}
post('/admin/categories/create') { Category.create(name: params[:name], description: params[:description]); redirect '/admin/categories'}
post('/admin/categories/update') { Category.refresh(params[:id], params[:name], params[:description]); redirect '/admin/categories'}
post('/admin/categories/delete') { Category.destroy(params[:id].to_i); redirect '/admin/categories'}

get( '/admin/guides') { @guides = Guide.all; haml :'/admin/guides/index' }
get( '/admin/guides/new') { haml :'/admin/guides/new' }
post('/admin/guides/create') { Guide.create(title: params[:title], category_id: params[:category].to_i, text: params[:text]); redirect '/admin/guides'}
get( '/admin/guides/show/:id') { haml :'/admin/guides/form' }
post('/admin/guides/update') {}
post('/admin/guides/delete'){}
=end
