require 'sinatra'
require 'pg'
require 'pry'
require 'sinatra/flash'

enable :sessions


def db_connection
  begin
    connection = PG.connect(dbname: "collaborarts")
    yield(connection)
  rescue PG::Error
    flash[:warning] = "Your email has already been used."
    redirect '/collaborarts/form'

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
$my_email = ""
  db_connection do |conn|
    conn.exec_params("INSERT INTO users (full_name, email, location, artist_type, looking_for, description) VALUES ($1, $2, $3, $4, $5, $6)", submission)
end

 $looking_for = submission[4]
 $my_email = submission[1]

  redirect '/collaborarts/results'

end


get '/collaborarts/results' do
  results = ""
db_connection do |conn|
  results = conn.exec("SELECT full_name, email, location FROM users WHERE artist_type = $1",  [$looking_for])
  end

  results = results.to_a

  if results.empty?
    flash[:alert] = "Sorry, there are no matches for that category."
    redirect '/collaborarts/form'
  end

  if results[-1]["email"] == $my_email
    results.slice!(-1)
  end



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
