class SuperMemo
  attr_accessor :pre_interval, :correct_answers_counter, :ef, :time, :typo

  def initialize(previous_interval, correct_answers_counter, ef, time, typo)
    @interval = previous_interval
    @correct_answers_counter = correct_answers_counter
    @ef = ef
    @time = time
    @typo = typo
  end

  def answers_quality
    answer_time = @time.to_i
    if @typo == 0 && answer_time < 15.seconds
      5
    elsif @typo == 1 && answer_time < 15.seconds
      4
    elsif @typo == 0 && answer_time > 15.seconds
      3
    elsif @typo == 1 && answer_time > 15.seconds
      2
    else
      1
    end
  end

  def set_interval
    case @correct_answers_counter
    when 1
      1
    when 2
      6
    else
      (@interval*get_ef).round
    end
  end

  def get_ef
    new_ef = @ef + (0.1 - (5-answers_quality)*(0.08+(5-answers_quality)*0.02))
    if new_ef < 1.3
      new_ef = 1.3
    end
    new_ef
  end
end