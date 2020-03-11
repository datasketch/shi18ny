const selectLangBinding = new Shiny.InputBinding();
// Si siempre hay un boton activo
let selectClicked;

$.extend(selectLangBinding, {
  find: function(scope) {
    return $(scope).find('.btn-group');
  },
  initialize: function(el) {
    //el.dataset.selected = '';
    var $el = $(el);
    el.dataset.selected = $el.attr('data-init-value');
  },
  getValue: function(el) {
    return el.dataset.selected;
  },
  subscribe: function(el, callback) {
    // Enlaza eventos al elemento que se creo
    $(el).on('click.selectLangBinding', function(event) {
      let target = event.target;
      console.log(target);
      if (target.matches('a.selectLang')) {
        el.dataset.selected = target.id;
      } else if (target.matches('a.selectLang img')) {
        target = target.parentNode;
        el.dataset.selected = target.id;
      } else if (target.matches('li.selectLang')) {
        target = target.querySelector('a.selectLang');
        el.dataset.selected = target.id;
      }
      const button = el.querySelector('.buttonInner.selectLang');
      if (target.matches('a')) {
        button.innerHTML = target.innerHTML;
      }
      callback();
    });
  },
  receiveMessage: function(el, data) {
    var $el = $(el);
    if(data.selected){
      var elId = "#" + data.selected;
      var selected = el.querySelector(elId);
      el.dataset.selected = data.selected;
      const button = el.querySelector('.buttonInner.selectLang');
      button.innerHTML = selected.innerHTML;
    }
    $el.trigger("click");
  }
});

Shiny.inputBindings.register(selectLangBinding, 'shiny.selectLangInput');
