class Clock.Views.HeaderView extends Backbone.View
  el: $('header')

  initialize: =>
    view = new Clock.Views.EditableView({
      displayElement: this.$('.hoverable')
      inputElement: this.$('input')
      renderValue: =>
        this.$('h1').text(this.title())
      inputText: this.title
      changeLink: this.$('a.edit')
      update: (value) =>
        value = '\u00A0' if value.match /^\s+$/
        value = null if value == this.genericTitle() or value == ''
        this.model.set({ title: value })
    })
    this.model.bind('change:title', view.render)
    this.model.bind('change:buyin_money', view.render)
    this.model.bind('change:rebuy', view.render)

  title: =>
    this.model.get('title') or this.genericTitle()

  genericTitle: =>
    title = I18n.t('clocks.game.generic_title.base', { buyin: I18n.toCurrency(this.model.get('buyin_money')) })
    title += I18n.t('clocks.game.generic_title.rebuys') if this.model.get('rebuy')
    title
