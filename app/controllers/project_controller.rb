class ProjectController < ApplicationController
  layout = 'project'
  before_action :check_authenticate, only: [:index, :show]
  before_action :set_project, only: [:show, :delete]
  before_action :set_members, only: [:index]
  before_action :set_user, only: [:index, :show]
  before_action :set_panel_options, only: [:show, :update, :getCurrentProject]

  def index
    @search_string = params[:search_string].present? ? params[:search_string] : ''

    @all_projects = Project.all.order('created_at desc').where('title LIKE ?', '%'+@search_string+'%')
    @projects = Array.new
    @user = User.find(session[:user_id])

    @time = Time.new

    if session[:isAdmin]
      @projects = @all_projects
    else
      @all_projects.each {|project| if @user.projects.include?(project) || Project.public_projects.include?(project); @projects.push project end }
    end
    @projects = @projects.paginate(:page => params[:page], :per_page => Pivotal::Application::config.project_per_page)

    @page = 'project-index'
  end

  def create
    @project_params = project_params
    @img_param = project_params[:img_url]
    @project_params.delete(:img_url)

    @project = Project.new(project_params)

    project_upload_path = 'uploads/project'
    if !File.directory?(File.join('public', project_upload_path))
      Dir.mkdir(File.join('public', project_upload_path))
    end

    if @project.save
      if @img_param.present?
        project_img_directory = File.join(project_upload_path, @project[:id].to_s)

        path = File.join(project_img_directory , @img_param.original_filename)
        @project[:img_url] = path
        @project.save

        if !File.directory?(File.join('public', project_img_directory))
          Dir.mkdir(File.join('public', project_img_directory))
        end

        File.open(File.join('public', path), "wb") { |f| f.write(@img_param.read) }

        redirect_to '/project/index'
      end
    end

    @memberIds = project_members[:members].split(',')
    @project.users = User.where(id: @memberIds)
  end

  def delete
    @project.destroy
  end

  def show
    my_projects = get_my_projects
    my_project_ids = my_projects.map {|project| project.id}
    if @project.blank?
        redirect_to '/project/index'
    else
      if my_project_ids == [] || !my_project_ids.include?(@project.id)
        redirect_to '/project/index'
      end

      @expand_story = 0
      if params[:story_id].present?
        @expand_story = params[:story_id].to_i
      end
      @page = 'project-detail'

      session[:current_project] = @project[:id]
    end
  end

  def update
    @update_project_params = update_params
    @memberIds = update_params[:members].split(',').map {|memberid| memberid.to_i }
    @update_project_params.delete(:members)
    @project = Project.find(@update_project_params[:id])

    if @update_project_params[:security] == '0'
      @project.relation_user_projects.destroy_all
    elsif @update_project_params[:security] == '1'
      @add_members = @memberIds - @project.getMemberIds

      @project.users = User.where(id: @memberIds)
      User.where(id: @add_members).each {|user| PivotalMailer.update_project(@project, user).deliver_later }

      @project.stories.each do |story|
        story.relation_user_stories.where.not(user_id: @memberIds).destroy_all
        story.awards.where.not(user_id: @memberIds).destroy_all
      end
    end
    @project.update(@update_project_params)
  end

  def getCurrentProject
    @project = Project.find(params[:id])
  end

  private
    def get_my_projects
      @all_projects = Project.all.order('created_at desc')
      @projects = Array.new
      @user = User.find(session[:user_id])

      if session[:isAdmin]
        @projects = @all_projects
      else
        @all_projects.each {|project| if @user.projects.include?(project) || Project.public_projects.include?(project); @projects.push project end }
      end

      return @projects
    end
    def set_project
      @project
      if Project.find_by_id(params[:id]) != nil
        @project = Project.find(params[:id])
      end
    end
    def set_members
      @members = User.getMembers
    end
    def set_user
      @user = User.find(session[:user_id])
    end
    def set_panel_options
      default_panel_options = [
          {"panel_type" => 'my_work', "is_visible" => true},
          {"panel_type" => 'current', "is_visible" => true},
          {"panel_type" => 'backlog', "is_visible" => true},
          {"panel_type" => 'test', "is_visible" => true},
          {"panel_type" => 'done', "is_visible" => true}
      ]

      @panel_options = cookies[:panel_options].present? ? JSON.parse(cookies[:panel_options]) : default_panel_options
    end
    def project_params
      params.require(:project).permit(:title, :startdate, :estimatedenddate, :security, :img_url)
    end
    def update_params
      params.require(:project).permit(:id, :security, :members, :estimatedenddate)
    end
    def project_members
      params.require(:project).permit(:members)
    end
    def check_authenticate
      if session[:user_id].blank?
        @before_url = request.original_url
        redirect_to root_url, flash: {before_url: @before_url}
      end
    end
end