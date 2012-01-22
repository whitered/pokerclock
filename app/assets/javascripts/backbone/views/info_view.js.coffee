class Clock.Views.InfoView extends Backbone.View
  el: $('#info')

  template: JST['backbone/templates/info']

  chipsTemplate: JST['backbone/templates/chips']

  initialize: =>
    game = this.model
    players = game.players
    this.el.html(this.template())
    _.each('buyin_money rebuy_money addon_money'.split(' '), (property) ->
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
    game.bind('change:rebuy', this.handleChangeMode)
    game.bind('change:addon', this.handleChangeMode)
    players.bind('add', this.render)
    players.bind('remove', this.render)
    players.bind('change', this.render)
    this.handleChangeMode()

  events:
    'click a.add_rebuys' : 'addRebuys'
    'click a.remove_rebuys' : 'removeRebuys'
    'click a.add_addon' : 'addAddon'
    'click a.remove_addon' : 'removeAddon'

  addRebuys: =>
    this.model.set { rebuy: true }
    false

  removeRebuys: =>
    this.model.set { rebuy: false }
    false

  addAddon: =>
    this.model.set { addon: true }
    false

  removeAddon: =>
    this.model.set { addon: false }
    false

  handleChangeMode: =>
    table = this.$('table').first()
    rebuy = this.model.get('rebuy')
    addon = this.model.get('addon')
    table.toggleClass('rebuys', rebuy)
    table.toggleClass('no-rebuys', !rebuy)
    table.toggleClass('addon', addon)
    table.toggleClass('no-addon', !addon)
    this.render()


  render: =>
    playersLeft = this.model.activePlayers().length
    totalChips = this.model.totalChips()
    totalCharge = this.model.totalCharge()
    averageChipsText = if playersLeft > 0
                     value = Math.round(totalChips * 100 / playersLeft) / 100
                     this.chipsTemplate({ value: value })
                   else
                     '?'
    this.$('#average_chips').html(averageChipsText)
    this.$('#total_chips').html(this.chipsTemplate({ value: totalChips }))
    this.$('#bank').text(I18n.toCurrency(totalCharge))
    this
