class TemplateController < ApplicationController
  skip_before_action :authenticate_user, only: [:page]

  def page
    render params[:page]
  end

end
