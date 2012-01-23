class Clock.Models.Player extends Backbone.Model

  defaults:
    name: null
    rebuys: 0
    addon: false
    positionIn: null
    positionOut: null

  initialize: =>
    this.bind('change:rebuys', this.handleChangeRebuys)
    this.bind('change:addon', this.handleChangeAddon)

  validate: =>
    return 'Player should have name' unless this.get('name')?

  handleChangeRebuys: =>
    window.undoManager.add(this, this.set, { rebuys: this.previous('rebuys') }, I18n.t('clocks.action.rebuy', player: this.get('name')))

  handleChangeAddon: =>
    window.undoManager.add(this, this.set, { addon: this.previous('addon') }, I18n.t('clocks.action.addon', player: this.get('name')))
  
  charge: =>
    game = window.game
    sum = game.get('buyin_money')
    sum += game.get('rebuy_money') * this.get('rebuys') if game.get('rebuy')
    sum += game.get('addon_money') if game.get('addon') && this.get('addon')
    sum

  chipsBought: =>
    game = window.game
    sum = game.get('buyin_chips')
    sum += game.get('rebuy_chips') * this.get('rebuys') if game.get('rebuy')
    sum += game.get('addon_chips') if game.get('addon') && this.get('addon')
    sum

  place: =>
    this.collection.length - this.get('positionOut') if this.get('positionOut')?

  win: =>
    place = this.place()
    if place?
      payout = window.game.payouts.at(place - 1)
      if payout?
        payout.value(window.game.totalCharge())
      else
        0

class Clock.Collections.PlayersCollection extends Backbone.Collection

  model: Clock.Models.Player

  localStorage: new Store('players')

  initialize: =>
    this.bind('change', this.handleChange)
    this.bind('add', this.handleAdd)
    this.fetch()

  handleChange: (player) =>
    player.save()
    this.sort()

  handleAdd: (player) =>
    player.set({ positionIn: this.length - 1 })
    player.save()
    window.undoManager.add(player, player.destroy, null, I18n.t('clocks.action.new_player', { name: player.get('name') }))

  comparator: (player) =>
    if player.get('positionOut')?
      this.length * 2 - player.get('positionOut')
    else
      player.get('positionIn')
