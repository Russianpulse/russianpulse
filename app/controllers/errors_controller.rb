class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def not_found
    respond_to do |format|
      format.html { render 'errors/not_found', status: :not_found }
      format.any { render text: 'not found', status: :not_found }
    end
  end

  def exception; end
end
