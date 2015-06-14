require 'sinatra'
require 'pg'
require 'pry'


def db_connection
  begin
    connection = PG.connect(dbname: "collaborarts")
#  rescue PG::UniqueViolation figure this out
    yield(connection)
  ensure
    connection.close
  end
end

def submission
  [params["full name"], params["email"], params["location"], params["artist type"], params["looking for"], params["description"]]
end

get '/' do
  redirect '/collaborarts/form'
end

get '/collaborarts/form' do
  erb :form
end

post '/collaborarts/form' do
$looking_for = ""
  db_connection do |conn|
    conn.exec_params("INSERT INTO users (full_name, email, location, artist_type, looking_for, description) VALUES ($1, $2, $3, $4, $5, $6)", submission)
  end

 $looking_for = submission[4]
  redirect '/collaborarts/results'

  binding.pry
end


get '/collaborarts/results' do
  results = ""
db_connection do |conn|
  results = conn.exec("SELECT full_name, email, location FROM users WHERE artist_type = $1",  [$looking_for])
  end
results = results.to_a
erb :results, locals: {results: results}
end

get '/collaborarts/:full_name' do
  info = db_connection do |conn|
    conn.exec("SELECT full_name, email, location, description
    FROM users
    WHERE full_name = $1", [params[:full_name]])
  end

    info = info.to_a

  erb :show, locals: {name: params[:full_name], info: info}
  end

  # get '/movies/:id' do
  # movie_info = db_connection { |conn| conn.exec("SELECT movies.title AS movie, movies.year AS year, movies.rating AS rating, genres.name AS genre, studios.name AS studio, actors.name AS actor, cast_members.character AS role, movies.synopsis AS synopsis
  #   FROM movies
  #   LEFT JOIN cast_members ON movies.id = cast_members.movie_id
  #   LEFT JOIN genres ON movies.genre_id = genres.id
  #   LEFT JOIN studios ON movies.studio_id = studios.id
  #   LEFT JOIN actors ON cast_members.actor_id = actors.id
  #   WHERE movies.title = $1", [params[:id]] )}
  # erb :'movies/show', locals: { movie: params[:id], movie_info: movie_info }
# end
