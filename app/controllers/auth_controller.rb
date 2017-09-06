class AuthController < ApplicationController
  layout 'login'

  def new
    @user = User.new
    if session[:user_id].present?
      redirect_to root_url
    end
  end

  def signup
    @user_params = user_params
    @avatar_param = @user_params[:avatar_url]
    @user_params.delete(:avatar_url)

    @user = User.new(@user_params)
    @user[:role] = 0
    @user[:activate_key] = DateTime.current.to_i

    user_upload_path = 'uploads/user'
    if !File.directory?(File.join('public', user_upload_path))
      Dir.mkdir(File.join('public', user_upload_path))
    end

    if @user.save
      PivotalMailer.signup(@user).deliver_later

      if @avatar_param.present?
        user_avatar_directory = File.join(user_upload_path, @user[:id].to_s)

        path = File.join(user_avatar_directory , @avatar_param.original_filename)
        @user[:avatar_url] = path
        @user.save

        if !File.directory?(File.join('public', user_avatar_directory))
          Dir.mkdir(File.join('public', user_avatar_directory))
        end

        File.open(File.join('public', path), "wb") { |f| f.write(@avatar_param.read) }

        redirect_to root_url
      end
    end
  end

  def loginpage
    @before_url = flash[:before_url]

    if session[:user_id].present?
      if @before_url.present?
        redirect_to @before_url
      else
        redirect_to action: 'index', controller: 'project'
      end
    else
      flash[:before_url] = @before_url
      render 'loginpage'
    end
  end

  def login
    @user = User.find_by_email(login_params[:email])
    @error_code = 0
    if @user.present?
      if @user[:is_activate] == 1
        if @user.password_string == login_params[:password_string]
          if @user[:role] == Pivotal::Application::config.admin_role
            session[:isAdmin] = true
          else
            session[:isAdmin] = false
          end
          session[:user_id] = @user[:id]
        else
          @error_code = 2
        end
      else
        @error_code = 3
      end
    else
      @error_code = 1
    end
  end

  def update
    @user = User.find(session[:user_id])

    @update_user_params = update_params
    if update_params[:password_string] == ''
      @update_user_params.delete(:password_string)
      @user.update(@update_user_params)
    else
      @user.update(update_params)
    end
  end

  def activate
    @user = User.find_by_activate_key(params[:activate_key])
    if @user.present?
      @user[:is_activate] = 1
      @user.save
      session[:user_id] = @user[:id]
      session[:isAdmin] = false
    end
    redirect_to root_url
  end

  def detail
    @member = User.find(params[:id])
    @page = 'auth-detail'
    @user = User.find(session[:user_id])
    @projects = Array.new

    if session[:isAdmin]
      @projects = Project.all.order('created_at desc')
    else
      Project.all.order('created_at desc').each {|project| if (@user.projects.include?(project) && @member.projects.include?(project)) || Project.public_projects.include?(project); @projects.push project end }
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to root_url
  end

  private
    # Only allow a trusted parameter "white list" through.
    def login_params
      params.require(:login).permit(:email,  :password_string)
    end
    def user_params
      params.require(:user).permit(:email, :avatar_url, :password_string, :firstname, :lastname, :gender, :birthdate)
    end
    def update_params
      params.require(:user).permit(:password_string, :firstname, :lastname, :gender, :birthdate)
    end
end
