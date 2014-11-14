class StaticPagesController < ApplicationController
  before_action :set_card

  def home
  end

  def review_card
    if @card.check_answer(params[:translate])
      @card.change_review_date
      flash[:right] = "Правильный ответ"
      redirect_to root_path
    else
      flash[:wrong] = "Неправильно. Попробуйте еще раз."
      redirect_to root_path
    end
  end

  private

    def set_card
      @card = Card.for_review
    end
end
