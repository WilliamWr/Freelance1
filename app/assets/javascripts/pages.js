$(function(){
  $(document).on('click', '.purchase-form-btn', function(event) {
    event.preventDefault();
    var self = $(this),
        isDone = self.attr('data-is-done') == 'true' ? true : false,
        $visibleTab = $(".tab-pane:visible"),
        $activeTab  = $(".nav.nav-tabs").find("li.active");

    if (isDone) {
      // DO AJAX
    }else{
      // Using the validated library check if the inputs are valid
      // is is valid going to remove disableTab class form the tab and go to the next tab
      if ($visibleTab.find("input").valid()) {
        var nextLi = $activeTab.next();
        $(nextLi).removeClass('disabledTab');
        $(nextLi).find("a").trigger('click');
      }
    }
  });
})

$(document).on('change', '[name="purchase[plan]"]', function(event) {
  event.preventDefault();
  var self = $(this),
      plan = self.closest('.plan');
  $(".plan").removeClass('plan-highlight')
  plan.addClass('plan-highlight')
});