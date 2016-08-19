class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def not_found
    respond_to do |format|
      format.html { render 'errors/not_found', status: 404 }
      format.any { render text: 'not found', status: 404 }
    end
  end

  def exception
  end
end
