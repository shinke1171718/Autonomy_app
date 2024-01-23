module SetValidationErrorHelper
  def set_validation_error(user)
    user.errors.full_messages.first.sub(/^.*\s/, '')
  end
end