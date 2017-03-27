class HomeController < ApplicationController
  respond_to :json
  # index action (not defined)

  # play action
  def play
    @move = params[:move].to_sym
    @game = Game.new( user_id: current_user.id )
    @game.threw = @move
    @game.against = Game.move
    p "@move: #{@move}"
    p "Game.move: #{Game.move}"
    p "@game: #{@game.inspect}"
    if @game.save
      respond_to do |format|
        format.html { render :index, notice: @game.result }
        format.js #{ render json: @game }
      end
    else
      respond_to do |format|
        # to do: make alert pull from i18n
        format.html { render :index, alert: 'Oops, there was a problem' }
        format.js #{ render json: {result: 'failure'} }
      end
    end
  end
end
