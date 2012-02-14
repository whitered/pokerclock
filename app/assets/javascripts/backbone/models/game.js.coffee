class Clock.Models.Game extends Backbone.Model

  localStorage: new Store('games')


  defaults:
    title: null
    levelDuration: 20 * 60 * 1000
    gameStart: null
    gameDuration: 0
    buyin: true
    rebuy: true
    addon: true
    buyin_money: 10
    rebuy_money: 10
    addon_money: 10
    buyin_chips: 5000
    rebuy_chips: 5000
    addon_chips: 5000
    description: null


  initialize: =>
    this.levels = new Clock.Collections.LevelsCollection
    this.players = new Clock.Collections.PlayersCollection
    this.payouts = new Clock.Collections.PayoutsCollection

    this.bind('change', this.handleChange)
    this.players.bind('bustout', this.handleBustout)
    this.levels.bind('apply', this.applyLevel)
    this.payouts.bind('change', this.recalculatePayouts)
    this.payouts.bind('add', this.recalculatePayouts)
    this.payouts.bind('remove', this.recalculatePayouts)
    this.payouts.bind('reset', this.recalculatePayouts)
    this.players.bind('add', this.recalculatePayouts)


  activePlayers: =>
    this.players.filter( (player) -> !player.get('positionOut')? )


  handleChange: =>
    this.save()


  handleBustout: (player) =>
    numActivePlayers = this.activePlayers().length
    positionOut = this.players.length - numActivePlayers
    player.set({ positionOut: positionOut })
    if numActivePlayers == 2
      winner = this.players.at(0)
      winner.set { positionOut: positionOut + 1 }
      window.undoManager.addAction(I18n.t('clocks.action.bustout', player: player.get('name')), ->
        player.set { positionOut: null }
        winner.set { positionOut: null }
      )
    else
      window.undoManager.add(player, player.set, { positionOut: null }, I18n.t('clocks.action.bustout', player:  player.get('name')))


  applyLevel: (level) =>
    passedLevels = this.levels.toArray().slice(0, this.levels.indexOf(level))
    summator = (ms, level) -> ms += level.get('duration') or this.game.get('levelDuration')
    gameTime = _.reduce(passedLevels, summator, 0)
    if this.get('gameStart')?
      this.set({ gameStart: (new Date).valueOf() - gameTime })
    else
      this.set({ gameDuration: gameTime })


  recalculatePayouts: =>
    totalCharge = this.totalCharge()
    outsiders = this.players.filter( (player) -> player.get('positionOut')? )
    _.each(outsiders, (player) =>
      payout = this.payouts.at(player.place() - 1)
      win = if payout then payout.calculate(totalCharge) else 0
      player.set({ win: win })
    )
    

  toggleTimer: =>
    start = this.get('gameStart')
    if start?
      this.set({
        gameDuration: (new Date).valueOf() - start
        gameStart: null
      })
    else
      this.set({
        gameStart: (new Date).valueOf() - this.get('gameDuration')
      })


  currentLevelInfo: =>
    start = this.get('gameStart')
    ms = if start? then (new Date).valueOf() - start else this.get('gameDuration')
    levelms = ms
    levelDuration = this.get('levelDuration')
    n = -1
    while (levelms >= 0) and (level = this.levels.at(++n))
      levelms -= level.get('duration') ? levelDuration

    {
      levelSecondsLeft: Math.ceil(-levelms / 1000)
      levelIndex: n
      level: level
      gameSeconds: Math.floor(ms / 1000)
      running: start != null
    }


  reset: =>
    this.set(this.defaults)
    this.players.destroyAll()
    this.levels.at(0).destroy() while this.levels.length > 0
    this.payouts.at(0).destroy() while this.payouts.length > 0
    this.levels.addNextLevel()
    this.payouts.add { rate: 100, percentage: true }


  totalChips: =>
    this.players.reduce( ((sum, player) -> sum += player.chipsBought()), 0)


  totalCharge: =>
    this.players.reduce( ((sum, player) -> sum += player.charge()), 0)
