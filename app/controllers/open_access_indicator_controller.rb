class OpenAccessIndicatorController < ApplicationController

  # A proxy method to get around CORS problems
  def get
    stats = OpenAccessIndicator.fetch(params[:resource], params[:year])
    if stats.present?
      render json: stats
    else
      render json: { error: 'Invalid response' }, status: :unprocessable_entity
    end
  end
end
