# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :load_game, :load_message_count
  before_action :check_captcha, :prevent_action_after_game, only: %i[new create]

  def new
    super
  end

  def create
    super
  end

  # DELETE /resource
  def destroy
    if resource.team_captain?
      set_flash_message! :alert, :captain_tried_to_destroy
      render 'edit'
    elsif params[:user] && resource.valid_password?(params[:user][:current_password])
      super
    else
      set_flash_message! :alert, :password_needed_destroy
      render 'edit'
    end
  end

  private

  def check_captcha
    return if verify_recaptcha

    self.resource = build_resource(sign_up_params)
    resource.validate
    clean_up_passwords(resource)
    set_flash_message! :alert, :recaptcha_failed
    render :new
  end
end
