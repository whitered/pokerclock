class Clock.Views.PayoutView extends Backbone.View
  tagName: 'li'

  template: JST['backbone/templates/payout']

  events:
    'blur input' : 'display'
    'dblclick' : 'edit'
    'keypress' : 'updateOnEnter'
    'click a.remove' : 'destroy'
    'click a.change' : 'edit'

  initialize: =>
    this.model.bind('change', this.render)
    this.el.id = this.model.cid

  display: =>
    $(this.el).removeClass('editing')
    this.model.parseString(this.$('input').val())
    this.$('input').val(this.model.formula())

  edit: =>
    width = this.$('.display').innerWidth()
    $(this.el).addClass('editing')
    this.$('input').css('width', width).select()
    false

  destroy: =>
    this.model.destroy()
    false

  updateOnEnter: (event) =>
    this.display() if event.keyCode == 13

  render: =>
    values = {
      value: I18n.toCurrency(this.model.value(this.bank))
      formula: this.model.formula()
    }
    $(this.el).html(this.template(values))
    this



class Clock.Views.PayoutsView extends Backbone.View
  el: $('#payouts ol')

  initialize: =>
    this.game = this.options.game
    this.model = this.game.payouts
    this.el.sortable({
      axis: 'y'
      update: this.handleSort
    })
    this.model.bind('add', this.render)
    this.model.bind('remove', this.render)
    players = this.game.players
    players.bind('add', this.render)
    players.bind('remove', this.render)
    players.bind('change', this.render)
    this.render()

  handleSort: (event, ui) =>
    this.model.setOrder(_.map(this.el.children(), (li) -> li.id))

  render: =>
    bank = this.game.totalCharge()
    el = this.el
    this.el.empty()
    this.model.each( (payout) ->
      view = new Clock.Views.PayoutView({ model: payout })
      view.bank = bank
      el.append(view.render().el)
    )
    this
