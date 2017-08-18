$(function(){
  $(document).on('click', '.purchase-form-btn', function(event) {
    event.preventDefault();
    var self = $(this),
        isDone = self.attr('data-is-done') == 'true' ? true : false,
        $visibleTab = $(".tab-pane:visible"),
        $activeTab  = $(".nav.nav-tabs").find("li.active");

    if (isDone) {
      // DO AJAX
      
      $.ajax({
        method: "POST",
        url: $("form").attr("action"),
        dataType: "json",
        data: $("form:visible").serializeObject()
      }).done(function(data){
        console.log(data)
      });
    }else{
      // Using the validated library check if the inputs are valid
      // is is valid going to remove disableTab class form the tab and go to the next tab
      if ($visibleTab.find("input").length < 1 || $visibleTab.find("input").valid()) {
        var nextLi = $activeTab.next();
        $(nextLi).removeClass('disabledTab');
        $(nextLi).find("a").trigger('click');

        if ($activeTab.find("a").attr("href") == '#step3') {
          self.attr('data-is-done', true);
        }
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


$.fn.serializeObject = function() {
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if (o[this.name]) {
			if (!o[this.name].push) {
				o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
};
