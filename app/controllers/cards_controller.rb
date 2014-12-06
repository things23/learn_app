class CardsController < ApplicationController
  before_action :find_card, only: [:show, :edit, :update, :destroy]
  before_action :find_deck, only: [:index, :new, :create]
  before_action :require_login

  def index
    @cards = @deck.cards
  end

  def show
  end

  def new
    @card = @deck.cards.new
  end

  def create
    @card = @deck.cards.new(cards_params.merge(user: current_user))

    if @card.save
      redirect_to deck_cards_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @card.update(cards_params)
      redirect_to @card
    else
      render 'edit'
    end
  end

  def destroy
    @deck = Deck.find(@card.deck_id)
    @card.destroy
    redirect_to deck_cards_path(@deck )
  end

  private

  def find_deck
    @deck = current_user.decks.find(params[:deck_id])
  end

  def find_card
    @card = current_user.cards.find(params[:id])
  end

  def cards_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :image, :remote_image_url)
  end

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
