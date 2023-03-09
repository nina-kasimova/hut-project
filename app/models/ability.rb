# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, Elective
    else
      can [:read], Elective
    end
  
    
  end
end
