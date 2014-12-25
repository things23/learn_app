$ ->
  start_time = new Date()
  $("#answer_submit").click ->
    time_for_answer = new Date() - start_time
    $(' input[name="time"]').val(time_for_answer)