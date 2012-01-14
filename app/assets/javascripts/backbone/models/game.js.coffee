class Clock.Models.Game extends Backbone.Model

  localStorage: new Store('games')


  defaults:
    levelDuration: 20 * 60 * 1000
    gameStart: null
    gameDuration: 0
    buyin_chips: 5000
    rebuy_chips: 5000
    addon_chips: 5000
    buyin: 1
    rebuy: 1
    addon: 1
    description: null


  initialize: =>
    this.levels = new Clock.Collections.LevelsCollection
    this.players = new Clock.Collections.PlayersCollection
    this.payouts = new Clock.Collections.PayoutsCollection

    this.bind('change', this.handleChange)
    this.players.bind('sitout', this.handleSitout)
    this.levels.bind('apply', this.applyLevel)


  validate: (attrs) =>
    _.each("buyin rebuy addon buyin_chips rebuy_chips addon_chips".split(' '), (attr) ->
      attrs[attr] = Number(attrs[attr]) if attrs[attr]
    )


  activePlayers: =>
    this.players.filter( (player) -> !player.get('place')? )


  handleChange: =>
    this.save()


  handleSitout: (player) =>
    place = this.players.filter( (player) -> return player.get('place') == null ).length
    payout = this.payouts.at(place - 1)
    win = if payout then payout.calculate(this.totalCharge()) else 0
    player.set({ place: place, win: win })
    window.undoManager.add(player, player.set, { place: null, win: null }, I18n.t('clocks.action.sitout', player:  player.get('name')))


  applyLevel: (level) =>
    passedLevels = this.levels.toArray().slice(0, this.levels.indexOf(level))
    summator = (ms, level) -> ms += level.get('duration') or this.game.get('levelDuration')
    gameTime = _.reduce(passedLevels, summator, 0)
    if this.get('gameStart')?
      this.set({ gameStart: (new Date).valueOf() - gameTime })
    else
      this.set({ gameDuration: gameTime })
    

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
    this.players.at(0).destroy() while this.players.length > 0
    this.levels.at(0).destroy() while this.levels.length > 0
    this.payouts.at(0).destroy() while this.payouts.length > 0
    this.levels.addNextLevel()
    this.payouts.add { rate: 100, percentage: true }


  totalChips: =>
    this.players.reduce( ((sum, player) -> sum += player.chipsBought()), 0)


  totalCharge: =>
    this.players.reduce( ((sum, player) -> sum += player.charge()), 0)
