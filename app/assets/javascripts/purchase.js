$(function(){
  var stripe = Stripe(document.head.querySelector("[name='stripe-key']").attributes.content.value);
  var elements = stripe.elements();
  var style = {
    base: {
      color: '#32325d',
      lineHeight: '24px',
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
      fontSmoothing: 'antialiased',
      fontSize: '16px',
      '::placeholder': {
        color: '#aab7c4'
      }
    },
    invalid: {
      color: '#fa755a',
      iconColor: '#fa755a'
    }
  };

  // Create an instance of the card Element
  var card = elements.create('card', {style: style});

  // Create a token when the form is submitted
  var form = document.getElementById('new_purchase');

  function stripeTokenHandler(token, opts) {
    // Insert the token ID into the form so it gets submitted to the server
    var form = document.getElementById('new_purchase');
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'purchase[ui_stripe_token]');
    hiddenInput.setAttribute('value', token.id);
    form.appendChild(hiddenInput);
    opts.formData['purchase[ui_stripe_token]'] = token.id;
    submitPurchaseForm(opts)
  }

  function createToken(opts) {
    stripe.createToken(card).then(function(result) {

      if (result.error) {
        // Inform the user if there was an error
        var errorElement = document.getElementById('card-errors');
        errorElement.textContent = result.error.message;
      } else {
        // Send the token to your server
        stripeTokenHandler(result.token, opts);
      }
    });
  };

  // Handle real-time validation errors from the card Element.
  card.addEventListener('change', function(event) {
    var displayError = document.getElementById('card-errors');
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = '';
    }
  });

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
          pricePerUnit = Number($(elem).attr('data-price')),
          planFeatures = $(elem).find('.plan-features');
        // check if there is any plan feature li, if is does add to storage items
        if (planFeatures.find('.plan-feature').length > 0) {
          temp[elemType] = [];
          planFeatures.find('.plan-feature').each(function(ix, el) {
            var count = $(el).find('[data-count]').attr('data-count');
            temp[elemType].push({
              total: pricePerUnit * Number(count),
              count: count,
              description: $(el).find('[data-desc]').attr('data-desc'),
            })
          })
          storage_items.push(temp);
        }
      })
      formData['purchase[storage_items]'] = JSON.stringify(storage_items);
      var finalTotal = storage_items.reduce(function(prevObjTotal, nextObj){
        var key = Object.keys(nextObj)[0]
        var totalObj = nextObj[key].reduce(function(prev, next){
          return prev + next.total
        },0)
        return prevObjTotal + totalObj
      }, 0)
      var plusReg = 0;
      if (formData["purchase[registration_fee_paid]"] === '0' || formData["purchase[registration_fee_paid]"] === 'true') {
        plusReg = 2500;
      }
      formData['purchase[amount]'] = finalTotal + plusReg;
      var opts = {
        formData: formData,
        url: url
      }

      // if ($("[name='stripeToken']").length > 0) {
      //   submitPurchaseForm(opts)
      // }else {
      createToken(opts);
      // }
    }else{
      // Using the validated library check if the inputs are valid
      // is is valid going to remove disableTab class form the tab and go to the next tab
      if ($visibleTab.find("input").length < 1 || $visibleTab.find("input").valid()) {
        var nextLi = $activeTab.next();
        $(nextLi).removeClass('disabledTab');
        $(nextLi).find("a").trigger('click');

        if ($activeTab.find("a").attr("href") == '#step3') {
          self.attr('data-is-done', true);
          // Add an instance of the card UI component into the `card-element` <div>
          card.mount('#card-element');
        }
      }
    }
  });
})

function submitPurchaseForm(opts){
  $.ajax({
    method: "POST",
    url: opts.url,
    dataType: "json",
    data: opts.formData
  })
  .done(function(data){
    if (!!data.errors && data.errors.length > 0) {
      Noty.closeAll();
      new Noty({
        text: data.errors,
        type: 'error',
        date: Date.now(),
      }).show();
    }
    location.reload();
  })
}


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
