class Clock.Views.FooterView extends Backbone.View
  el: $('footer')

  initialize: =>
    this.$('a.reset').inlineConfirmation(
      confirm: "<a href='#' class='btn btn-danger'>#{ I18n.t('clocks.footer.reset.confirm') }</a>"
      cancel: "<a href='#' class='btn'>#{ I18n.t('clocks.footer.reset.cancel') }</a>"
      separator: I18n.t('clocks.footer.reset.separator')
      expiresIn: 5
      confirmCallback: this.reset
    )

  reset: =>
    this.model.reset()
    false
