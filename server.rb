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
  [params["first name"], params["last name"], params["email"], params["artist type"], params["looking for"], params["description"]]
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
    conn.exec_params("INSERT INTO users (first_name, last_name, email, artist_type, looking_for, description) VALUES ($1, $2, $3, $4, $5, $6)", submission)
  end

 $looking_for = submission[4]
  redirect '/collaborarts/results'

  binding.pry
end


get '/collaborarts/results' do
  results = ""
db_connection do |conn|
  results = conn.exec("SELECT first_name, last_name, email FROM users WHERE artist_type = $1",  [$looking_for])
  end
results = results.to_a
erb :results, locals: {results: results}
end
