class Clock.Views.TimerView extends Backbone.View
  el: $('#timer')

  template: JST["backbone/templates/timer"]

  initialize: =>
    this.el.html(this.template())
    this.model.bind('change:gameStart', this.syncTimer)
    this.model.bind('change:gameDuration', this.render)
    this.model.bind('change:levelDuration', this.render)
    this.syncTimer(this.model, this.model.get('gameStart'))
    new Clock.Views.EditablePropertyView({
      el: this.$('#level_duration')
      model: this.model
      property: 'levelDuration'
      adjustInputWidth: true
      formatInput: (value) => this.formatTime(value / 1000)
      formatOutput: (value) => this.formatTime(value / 1000)
      processInput: (value) =>
        matches = value.match(/(\d+)\D*(\d+)?/)
        matches[1] * 60000 + (matches[2] || 0) * 1000
    })

  events:
    'click #round_time_left': 'toggleTimer'

  alarm: new Audio('/audio/fnrlbell.wav')

  syncTimer: (game, timer) =>
    this.el.stopTime('timer')
    if timer?
      this.el.everyTime(1000, 'timer', this.render)
    this.render()

  toggleTimer: =>
    this.model.toggleTimer()

  formatTime: (seconds) =>
    seconds ||= 0
    negative = seconds < 0
    seconds = -seconds if negative
    m = Math.floor(seconds / 60)
    s = seconds % 60
    m = '0' + m if m < 10
    s = '0' + s if s < 10
    (if negative then '-' else '') + m + ':' + s

  render: =>
    info = this.model.currentLevelInfo()
    if this.currentLevel != info.levelIndex
      this.model.trigger('change:level', info)
      this.alarm.play() if info.running && this.currentLevel?
      this.currentLevel = info.levelIndex
    this.$('#round_time_left').text(this.formatTime(info.levelSecondsLeft))
    this.$('#round_time_left').toggleClass('running', info.running)
    this.$('#game_time').text(this.formatTime(info.gameSeconds))
    this
