$ ->
  $('.follow .btn-success').hover ->
    $(this).toggleClass("btn-danger")
    console.log($(this).val())
    switch $(this).val()
      when "دنبال میکنید" then $(this).val("قطع ارتباط")
      when "قطع ارتباط" then $(this).val("دنبال میکنید")
      when "Thu" then go iceFishing
      when "Following" then $(this).val("Unfollow")
      when "Unfollow" then $(this).val("Following")