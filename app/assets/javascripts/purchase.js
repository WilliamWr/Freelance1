$(function(){
  $(document).on('click', '.purchase-form-btn', function(event) {
    event.preventDefault();
    var self = $(this),
        isDone = self.attr('data-is-done') == 'true' ? true : false,
        $visibleTab = $(".tab-pane:visible"),
        $activeTab  = $(".nav.nav-tabs").find("li.active");

    if (isDone) {
      var form    = $("form:visible"),
        allPlan   = $("[data-type='plans-features']").find('.plan'),
        url       = form.attr("action");

      formData = form.serializeObject();
      var storage_items = [];
      allPlan.each(function(index, elem) {
        var temp = {},
          elemType = $(elem).attr('data-type'),
          planFeatures = $(elem).find('.plan-features');
        // check if there is any plan feature li, if is does add to storage items
        if (planFeatures.find('.plan-feature').length > 0) {
          temp[elemType] = [];
          planFeatures.each(function(ix, el) {
            temp[elemType].push({
              count: $(el).find('[data-count]').attr('data-count'),
              description: $(el).find('[data-desc]').attr('data-desc'),
            })
          })
          storage_items.push(temp);
        }
      })
      formData['purchase[storage_items]'] = JSON.stringify(storage_items);
      $.ajax({
        method: "POST",
        url: url,
        dataType: "json",
        data: formData
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

$(document).on('keyup', '.plan input[type="text"]', function(event) {
  event.preventDefault();
  var self = $(this),
      $plan = self.closest('.plan'),
      $features = $plan.find('.plan-features'),
      countField = $plan.find("[type='number']"),
      countVal = Number(countField.val()),
      descVal  = self.val();
  if (event.keyCode == 13 && countVal > 0 && descVal.length > 0) {
    $features.append(featureHTML(descVal, countVal))
    self.val('');
    countField.val('');
    countField.focus();
  }else{
    console.log("Count should be greater than one!")
  }
});

$(document).on('click', '.delete', function(event) {
  event.preventDefault();
  var self = $(this);
  planFeature = self.closest('.plan-feature');
  planFeature.hide();
});

function featureHTML(desc, count){
  return '<li class="plan-feature">\
            <span data-count="'+count+'" class="plan-feature-unit">'+count+'</span>\
            <span data-desc="'+desc+'" class="plan-feature-desc">'+desc+'</span>\
            <span class="delete">X</span>\
          </li>';
}

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
