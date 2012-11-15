class Clock.Views.PayoutView extends Backbone.View
  tagName: 'li'

  template: JST['backbone/templates/payout']

  initialize: =>
    this.el.id = this.model.cid
    $(this.el).html(this.template())
    view = new Clock.Views.EditableView({
      displayElement: this.$('.display')
      inputElement: this.$('input')
      changeLink: this.$('ul.actions a.change')
      inputText: => this.model.formula()
      update: (value) => this.model.parseString(value)
      renderValue: =>
        value = I18n.toCurrency(this.model.value(this.options.bank))
        formula = this.model.formula()
        percentage = this.model.get('percentage')
        this.$('span.amount').text(value).attr('title', formula)
        this.$('span.formula').text(if percentage then '(' + formula + ')' else '' )
    })
    this.model.bind('change', view.render)

  events:
    'click a.remove' : 'destroy'
    'click a.up' : 'moveUp'
    'click a.down' : 'moveDown'

  destroy: =>
    this.model.destroy()
    false

  moveUp: =>
    this.model.collection.moveUp(this.model)
    false

  moveDown: =>
    this.model.collection.moveDown(this.model)
    false



class Clock.Views.PayoutsView extends Backbone.View
  el: $('#payouts ol')

  initialize: =>
    this.game = this.options.game
    this.model = this.game.payouts
    this.el.sortable({
      axis: 'y'
      update: this.handleSort
    })
    this.el.mousedown( (event) =>
      document.activeElement.blur() if document.activeElement.nodeName == 'INPUT' && document.activeElement != event.target
    )
    this.model.bind('add', this.render)
    this.model.bind('remove', this.render)
    this.model.bind('reset', this.render)
    players = this.game.players
    players.bind('add', this.render)
    players.bind('remove', this.render)
    players.bind('change', this.render)
    this.game.bind('change:rebuy', this.render)
    this.game.bind('change:addon', this.render)
    this.game.bind('change:buyin_money', this.render)
    this.game.bind('change:rebuy_money', this.render)
    this.game.bind('change:addon_money', this.render)
    this.render()

  handleSort: (event, ui) =>
    this.model.setOrder(_.map(this.el.children(), (li) -> li.id))

  render: =>
    bank = this.game.totalCharge()
    el = this.el
    this.el.empty()
    this.model.each( (payout) ->
      view = new Clock.Views.PayoutView({ model: payout, bank: bank })
      el.append(view.render().el)
    )
    this
