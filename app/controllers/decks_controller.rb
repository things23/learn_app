class DecksController < ApplicationController
  def index
    @decks = current_user.decks
  end

  def new
    @deck = current_user.decks.new
  end

  def create
    @deck = current_user.decks.new(decks_params)

    if @deck.save
      redirect_to decks_path, notice: "New deck was created"
    end
  end

  def destroy
    @deck = current_user.decks.find(params[:id])
    @deck.destroy
    redirect_to decks_path
  end

  private

    def decks_params
      params.require(:deck).permit(:title)
    end
end