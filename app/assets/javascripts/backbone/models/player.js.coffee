class Clock.Models.Player extends Backbone.Model

  defaults:
    name: null
    rebuys: 0
    addon: false
    place: null
    win: 0

  initialize: =>
    this.bind('change:rebuys', this.handleChangeRebuys)
    this.bind('change:addon', this.handleChangeAddon)

  validate: =>
    return 'Player should have name' unless this.get('name')

  handleChangeRebuys: =>
    window.undoManager.add(this, this.set, { rebuys: this.previous('rebuys') }, I18n.t('clocks.action.rebuy', player: this.get('name')))

  handleChangeAddon: =>
    window.undoManager.add(this, this.set, { addon: this.previous('addon') }, I18n.t('clocks.action.addon', player: this.get('name')))
  
  charge: =>
    game = window.game
    sum = game.get('buyin') + game.get('rebuy') * this.get('rebuys')
    sum += game.get('addon') if this.get('addon')
    return sum

  chipsBought: =>
    game = window.game
    sum = game.get('buyin_chips') + game.get('rebuy_chips') * this.get('rebuys')
    sum += game.get('addon_chips') if this.get('addon')
    return sum



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
    player.save()
    window.undoManager.add(player, player.destroy, null, I18n.t('clocks.action.new_player', { name: player.get('name') }))

  comparator: (player) =>
    player.get('place')
