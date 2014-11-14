class StaticPagesController < ApplicationController
  before_action :set_card

  def home
  end

  def check
    if @card.correct(params[:translate])
      @card.review_later
      flash[:right] = "Правильный ответ"
      redirect_to root_path
    else
      flash[:wrong] = "Неправильно. Попробуйте еще раз."
      redirect_to root_path
    end
  end

  private
    def set_card
      @card = Card.to_exercise.ordered.first
    end
end