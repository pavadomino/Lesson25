require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
  @error = 'Something wrong!'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  hh = { :username => 'Введите имя',
         :phone => 'Введите номер телефона',
         :datetime => 'Введтие дату и время'}

  @error = hh.select { |key,_| params[key] == ''}.values.join(", ")

  if @error != ''
    return erb :visit
  end

#  hh.each do |key, value|
#    if params[key] == ''
#      @error = hh[key]
#      return erb :visit
#    end
#  end

  #if @username == ''
   # @error = 'Введите имя'
    #return erb :visit
  #else
    file = File.open('./public/users.txt', 'a')
    file.write("User: #{@username}, Phone: #{@phone}, Datetime: #{@datetime}, Barber: #{@barber}, Color: #{@color}\n")
    file.close
    erb "#{@username} Вы были успешно записаны!"
  #end
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
  @email = params[:email]
  @comments = params[:comments]
  f = File.open('./public/contacts.txt', 'a')
  f.write("Email: #{@email} \nComment:\n#{@comments}\n#{'-' * 20}\n")
  f.close
  #erb :contacts
  Pony.mail({
    :from => 'pavadomino@gmail.com',
    :to => 'pavadomino@gmail.com',
    :via => :smtp,
    :subject => "Message from #{@email}",
    :body => "Please check comments from the client:\n#{@comments}",
    :attachments => {"contacts.txt" => File.read("./public/contacts.txt")},
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'pavadomino@gmail.com',
      :password             => 'smwirnyjmzkrnfyd',
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "gmail.com" # the HELO domain provided by the client to the server
    }
  })

  erb 'Ваш запрос был отправлен!'
end
