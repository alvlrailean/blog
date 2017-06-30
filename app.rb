require 'sinatra'
require 'rubygems'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	@db = SQLite3::Database.new 'database.db'
	@db.results_as_hash = true
	
end

before do
	get_db

	@dbSelArt = @db.execute 'select * from Posts order by id desc'
end

configure do
	get_db
	@db.execute 'CREATE TABLE if not exists Posts 
	(
	id	INTEGER PRIMARY KEY AUTOINCREMENT,
	title	TEXT,
	content	TEXT,
	data	DATE
	)'


end

get '/' do 
	erb :index
end

get '/articles' do
	@dbSelArt = @db.execute 'select * from Posts'

	erb :articles
end

post '/articles' do
	@textArticle = params[:textArticle]
	@title = params[:title]



	if @textArticle == '' || @title == ''
		@error = 'Неправильный ввод. Поля Заголовок и Текст не могут быть пустыми'
		return erb :articles
	end 
@db.execute 'insert into Posts (title, content, data) values (?, ?, datetime())',[@title, @textArticle]
@db.close

erb :artPrev

end

post '/artPrev' do
	erb :articles
end
