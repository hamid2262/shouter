jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 100
        $('.pagination').html( "<img src=\"http://s3-eu-west-1.amazonaws.com/hamsafaryab.production/static_files/images/loader.gif\" %>" )
        $.getScript(url)
    $(window).scroll()