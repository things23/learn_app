class StaticPagesController < ApplicationController
  before_action :render_landing?

  def home
    if current_user.decks.any?
      if current_user.current_deck
        @cards = current_user.decks.find(current_user.current_deck_id).cards
      else
        @cards = current_user.cards
      end
      @card = @cards.for_review.first
    else
      redirect_to decks_path, notice: "Для начала тренировок создайте колоду"
    end
  end

  def review_card
    @card = Card.find(params[:card_id])
    if @card.check_answer(params[:translation])
      @card.change_review_date
      flash[:right] = "Правильный ответ"
    else
      flash[:wrong] = "Неправильный ответ"
    end
    redirect_to root_path
  end

  private

  def render_landing?
    render "landing" unless current_user
  end
end
