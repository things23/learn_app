class CardsController < ApplicationController
  before_action :find_card, only: [:edit, :update, :destroy]
  before_filter :require_login

  def index
    @cards = current_user.cards
  end

  def show
  end

  def new
    @card = current_user.cards.new
  end

  def create
    @card = current_user.cards.new(cards_params)

    if @card.save
      redirect_to cards_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @card.update(cards_params)
      redirect_to cards_path
    else
      render 'edit'
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path
  end

  private

  def find_card
    @card = Card.find(params[:id])
  end

  def cards_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
