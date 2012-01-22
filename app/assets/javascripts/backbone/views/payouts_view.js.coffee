class Clock.Views.PayoutView extends Backbone.View
  tagName: 'li'

  template: JST['backbone/templates/payout']

  events:
    'dblclick' : 'edit'
    'blur input' : 'update'
    'keypress input' : 'updateOnEnter'
    'click a.change' : 'edit'
    'click a.remove' : 'destroy'
    'click a.up' : 'moveUp'
    'click a.down' : 'moveDown'

  initialize: =>
    this.model.bind('change', this.render)
    this.el.id = this.model.cid

  edit: =>
    width = this.$('.display').innerWidth()
    $(this.el).addClass('editing')
    this.$('input').css('width', width).select()
    false

  update: =>
    input = this.$('input')
    $(this.el).removeClass('editing')
    this.model.parseString(input.val())
    input.val(this.model.formula())

  destroy: =>
    this.model.destroy()
    false

  updateOnEnter: (event) =>
    this.update() if event.keyCode == 13

  moveUp: =>
    this.model.collection.moveUp(this.model)
    false

  moveDown: =>
    this.model.collection.moveDown(this.model)
    false

  render: =>
    values = {
      value: I18n.toCurrency(this.model.value(this.options.bank))
      formula: this.model.formula()
      percentage: this.model.get('percentage')
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
    this.el.mousedown( =>
      document.activeElement.blur() if document.activeElement.nodeName == 'INPUT'
    )
    this.model.bind('add', this.render)
    this.model.bind('remove', this.render)
    players = this.game.players
    players.bind('add', this.render)
    players.bind('remove', this.render)
    players.bind('change', this.render)
    this.game.bind('change:rebuy', this.render)
    this.game.bind('change:addon', this.render)
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
