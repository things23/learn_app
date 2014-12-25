class SuperMemo

  def initialize(previous_interval, correct_answers_counter, ef, time, levenshtein_distance)
    @prev_interval = previous_interval
    @correct_answers_counter = correct_answers_counter
    @ef = ef
    @time = time
    @levenshtein_distance = levenshtein_distance
  end

  def answers_quality
    answer_time = @time.to_i
    if @levenshtein_distance == 0 && answer_time < 15.seconds
      5
    elsif @levenshtein_distance == 1 && answer_time < 15.seconds
      4
    elsif @levenshtein_distance == 0 && answer_time > 15.seconds
      3
    elsif @levenshtein_distance == 1 && answer_time > 15.seconds
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
      (@prev_interval * ef).round
    end
  end

  # the formula from http://www.supermemo.com/english/ol/sm2.htm

  def ef
    new_ef = @ef + (0.1 - (5 - answers_quality) * (0.08 + (5 - answers_quality) * 0.02))
    [new_ef, 1.3].max
  end
end
