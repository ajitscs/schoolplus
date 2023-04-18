# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    # byebug
    return unless user.present?
    if user.school_admin?
      can :manage, User # can manage the students
      can :update, School # can udpate his own school info
      can :show, School # can see his own school info
      can :manage, Course # can manage the courses
      can :manage, Batch # can manage the batches
      can :manage, StudentBatch # can manage enrollment requests
    end

    if user.admin?
      can :manage, :all # can manage every thing across the platform
    end

    if user.student?
      can :read, User # show batchmates on users index page
      can :enrol, Batch # show batches list page
      can :create, StudentBatch # can create enrollment request
      can :classmates, StudentBatch # can see the batchmates 
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
