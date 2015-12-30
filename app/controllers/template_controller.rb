class TemplateController < ApplicationController

  def page
    render params[:page]
  end

end
