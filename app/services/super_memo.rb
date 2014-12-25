class SuperMemo
  attr_accessor :interval, :correct_answers_counter, :ef, :time, :typo

  def initialize(interval, correct_answers_counter, ef, time, typo)
    @interval = interval
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

  def interval
    case @correct_answers_counter
    when 1
      1
    when 2
      6
    else
      (@interval * ef).round
    end
  end
  #the formula from http://www.supermemo.com/english/ol/sm2.htm
  def ef
    new_ef = @ef + (0.1 - (5 - answers_quality) * (0.08 + (5 - answers_quality) * 0.02))
    [new_ef, 1.3].max
  end
end
