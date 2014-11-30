class StaticPagesController < ApplicationController

  def home
    if current_user
      if current_user.decks.present?
        if current_user.current_deck
          @cards = current_user.current_deck.cards
        else
          @cards = current_user.cards
        end
        @card = @cards.for_review.first
      else
        redirect_to decks_path, notice: "Для начала тренировок создайте колоду"
      end
    else
      redirect_to landing_path
    end
  end

  def landing
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
end
