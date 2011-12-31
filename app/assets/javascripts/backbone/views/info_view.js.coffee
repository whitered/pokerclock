class Clock.Views.InfoView extends Backbone.View
  el: $('#info')

  template: JST['backbone/templates/info']

  chipsTemplate: JST['backbone/templates/chips']

  initialize: =>
    game = this.model
    players = game.players
    this.el.html(this.template())
    _.each('buyin rebuy addon'.split(' '), (property) ->
      new Clock.Views.EditablePropertyView({
        el: this.$('#' + property)
        model: game
        property: property
        adjustInputWidth: true
        inputAttributes: { type: 'number', min: 0 }
        formatOutput: (value) -> I18n.toCurrency(value)
      })
    )
    _.each('buyin_chips rebuy_chips addon_chips'.split(' '), (property) =>
      new Clock.Views.EditablePropertyView({
        el: this.$('#' + property)
        model: game
        property: property
        adjustInputWidth: true
        inputAttributes: { type: 'number', min: 0 }
        formatOutput: (value) => this.chipsTemplate({ value: value })
      })
    )
    game.bind('change:buyin_chips', this.render)
    game.bind('change:rebuy_chips', this.render)
    game.bind('change:addon_chips', this.render)
    players.bind('add', this.render)
    players.bind('remove', this.render)
    players.bind('change', this.render)
    this.render()

  render: =>
    playersLeft = this.model.activePlayers().length
    totalChips = this.chipsTemplate({ value: this.model.totalChips() })
    totalCharge = this.model.totalCharge()
    averageChips = if playersLeft > 0
                     value = Math.round(totalChips * 100 / playersLeft) / 100
                     this.chipsTemplate({ value: value })
                   else
                     '?'
    this.$('#average_chips').html(averageChips)
    this.$('#total_chips').html(totalChips)
    this.$('#bank').text(I18n.toCurrency(totalCharge))
    return this
