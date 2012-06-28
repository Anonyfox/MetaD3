#/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'haml'
require 'coffee-script'
require 'active_record'
require 'sqlite3'
require_relative 'lib/database'

before do 
  db = Database.new
end

#######################################################
### main sites
#######################################################

get( '/') { haml :index }
get( '/simulator') { haml :'simulator/simulator' }
get( '/js/simulator/simulator.coffee') { coffee :'simulator/simulator' }

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
