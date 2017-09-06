require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :firstname, :lastname
  has_many :awards

  has_and_belongs_to_many(
      :projects,
      :join_table => 'relation_user_projects',
      :foreign_key => "user_id",
      :association_foreign_key => "project_id"
  )
  has_and_belongs_to_many(
      :stories,
      :join_table => 'relation_user_stories',
      :foreign_key => "user_id",
      :association_foreign_key => "story_id"
  )

  def get_processing_project_stories(project_id)
    stories.where(project_id: project_id, status: [1,2])
  end

  def get_beforestart_project_stories(project_id)
    stories.where(project_id: project_id, status: [0,3])
  end

  def get_done_project_stories(project_id)
    stories.where(project_id: project_id, status: 4)
  end

  def short_name
    firstname + ' ' + lastname[0] + lastname[lastname.length-1]
  end

  def full_name
    firstname + ' ' + lastname
  end

  def password_string
    @password ||= Password.new(password)
  end

  def password_string=(new_password)
    @password = Password.create(new_password)
    self.password = @password
  end

  class << self
    def getAdmin
      find_by_role(Pivotal::Application::config.admin_role)
    end

    def getMembers
      where(:role => 0, :is_activate => 1)
    end

    def getSortingMembers(project_id)
      @project = Project.find(project_id)
      users = @project[:security] == 0 ? getMembers : @project.users
      users.sort_by { |user| user.stories.where(:project_id => project_id, :status => 4).sum('points') }.reverse
    end
  end
end
