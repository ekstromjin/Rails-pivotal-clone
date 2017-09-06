require 'will_paginate/array'
class Project < ActiveRecord::Base
  has_and_belongs_to_many(
      :users,
      :join_table => 'relation_user_projects',
      :foreign_key => "project_id",
      :association_foreign_key => "user_id"
  )
  has_many :stories
  has_many :relation_user_projects

  def getMemberNames
    users(true).map {|user| user.short_name}.join(', ')
  end

  def getMemberIds
    users(true).map {|user| user.id}
  end

  def isProjectDone
    stories.length == stories.where(:status => 4).length && estimatedenddate < Date.today
  end

  def getCurrentStories(session)
    @me = User.find(session[:user_id])
    @stories = Array.new
    stories(true).where(status: [0, 1]).order('created_at asc').each {|story| if !story.users.include?(@me) then @stories.push story end }
    @stories
  end

  def getMyworkStories(session)
    @me = User.find(session[:user_id])
    @stories = Array.new
    stories(true).where(status: [0, 1]).order('created_at asc').each {|story| if story.users.include?(@me) then @stories.push story end }
    @stories
  end

  def getBacklogStories
    stories(true).where(status: 3).order('created_at asc')
  end

  def getTestStories
    stories(true).where(status: 2).order('created_at asc')
  end

  def getDoneStories
    stories(true).where(status: 4).order('created_at asc')
  end

  def getProcessingStories
    stories(true).where(status: [1, 2]).order('created_at asc')
  end

  def getBeforeBeginStories
    stories(true).where(status: [0, 3]).order('created_at asc')
  end

  def getMembers
    security == 0 ? User.getMembers : users(true)
  end

  class << self
    def public_projects
      where :security => 0
    end
  end
end