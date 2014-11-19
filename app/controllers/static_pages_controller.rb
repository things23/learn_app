class StaticPagesController < ApplicationController
  def home
    @card = Card.for_review.first
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
