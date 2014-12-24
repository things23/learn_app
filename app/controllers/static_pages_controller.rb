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
    @translation = params[:translation]
    @check_translation = @card.check_answer(@translation, params[:time])
    if @check_translation == 0
      flash[:right] = "Правильный ответ"
    elsif @check_translation == 1
      flash[:right] = "Правильно! Вы допустили одну опечатку: #{@translation}"
    else
      flash[:wrong] = "Неправильный ответ"
    end
    redirect_to root_path
  end
end
