class UsersController < ApplicationController
  include Devise::Controllers::Helpers
  before_action :authenticate_user!

  def index
  end
end
