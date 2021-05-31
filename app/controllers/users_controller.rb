class UsersController < ApplicationController
  
  def authenticate
    
    #Parameters: {"input_username"=>"hammad3", "input_password"=>"[FILTERED]"}

    #get username from params
    username = params.fetch("input_username")
    
    #get password from params
    password = params.fetch("input_password")

    #look up the record from the db matching username
    the_user = User.where({ :username => username}).first

    #if there's no record, redirect back to sign in form
    if the_user == nil
      redirect_to("/user_sign_in", { :alert => "No one by that name here"})
    
    #if there is a record, check if password matches
    else
      if the_user.authenticate(password)

    #if so, set the cookie
        session.store(:user_id, the_user.id)
        redirect_to("/", { :notice => "Welcome back, #{the_user.username}!"})
        
    #if not, redirect back to sign in form
      else
        redirect_to("/user_sign_in", { :alert => "Nice try, sucker!"})
      end
    end
    
  end


  def sign_in

    render({ :template => "users/sign_in_form.html.erb"})
  end


  def sign_out
    reset_session
    redirect_to("/", { :notice => "See ya later!"})
  end


  def new_registration_form
    render({ :template => "users/signup_form.html.erb"})
  end

  
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      #storing user id in a cookie
      session.store(:user_id, user.id)

      redirect_to("/users/#{user.username}", { :notice => "Welcome, #{user.username}!"})
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end

  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
