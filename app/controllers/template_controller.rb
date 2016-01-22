class TemplateController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :template]

  def index
    # render index page
  end

  def template
    template_path = 'template/' + (view_params[:module] ? view_params[:module] + "/" : "") + view_params[:name]
    render template_path
  end

  private

  def view_params
    params.permit(:module,:name)
  end

end
