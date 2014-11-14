class StaticPagesController < ApplicationController
  def home
    @card = Card.for_review.first
  end

  def review_card
    @card = Card.find_by(id: params[:card_id])
    if @card.check_answer(params[:translation])
      @card.change_review_date
      flash[:right] = "Правильный ответ"
      redirect_to root_path
    else
      flash[:wrong] = "Неправильный ответ"
      redirect_to root_path
    end
  end
end
