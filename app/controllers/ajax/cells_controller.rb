class Ajax::CellsController < ApplicationController
  CELLS = %w[most_discussed posts/controls posts/comments_link].freeze

  def show
    render html: cell(name, *JSON.parse(params[:args]))
  end

  private

  def name
    raise 'Unsupported cell name' unless CELLS.include?(params[:name])

    params[:name]
  end
end
