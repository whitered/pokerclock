class Clock.Views.TimerView extends Backbone.View
  el: $('#timer')

  template: JST["backbone/templates/timer"]

  initialize: =>
    this.el.html(this.template())
    this.syncTimer(this.model, this.model.get('gameStart'))
    levelDurationView = new Clock.Views.EditableView({
      displayElement: this.$('#level_duration_display')
      inputElement: this.$('#level_duration_input')
      changeLink: this.$('#level_duration_display a.action')
      inputText: => this.formatTime(this.model.get('levelDuration') / 1000)
      renderValue: =>
        text = this.formatTime(this.model.get('levelDuration') / 1000)
        this.$('#level_duration_display>span').text(text)
      update: (value) =>
        matches = value.match(/(\d+)(\D+(\d+))?(\D+(\d+))?/)
        if matches?
          if matches[5]?
            h = Number(matches[1])
            m = Number(matches[3])
            s = Number(matches[5])
          else
            h = 0
            m = Number(matches[1])
            s = Number(matches[3]) || 0
          ms = (h * 60 * 60 + m * 60 + s) * 1000
          this.model.set({ levelDuration: ms })
    })
    this.model.bind('change:gameStart', this.syncTimer)
    this.model.bind('change:gameDuration', this.render)
    this.model.bind('change:levelDuration', this.render)
    this.model.bind('change:levelDuration', levelDurationView.render)

    this.audio = document.createElement('audio')
    srcMp3 = document.createElement('source')
    srcMp3.src = '/sounds/gong.mp3'
    srcMp3.type = 'audio/mpeg'
    this.audio.appendChild srcMp3
    srcOgg = document.createElement('source')
    srcOgg.src = '/sounds/gong.ogg'
    srcOgg.type = 'audio/ogg'
    this.audio.appendChild srcOgg

  events:
    'click #round_time_left': 'toggleTimer'

  syncTimer: (game, timer) =>
    this.el.stopTime('timer')
    if timer?
      this.el.everyTime(1000, 'timer', this.render)
    this.render()

  toggleTimer: =>
    this.model.toggleTimer()

  formatTime: (seconds) =>
    s = seconds || 0
    negative = s < 0
    s = -s if negative
    h = Math.floor(s / 3600)
    s = s % 3600
    m = Math.floor(s / 60)
    s = s % 60
    m = '0' + m if m < 10
    s = '0' + s if s < 10
    t = m + ':' + s
    t = h + ':' + t if h > 0
    (if negative then '-' else '') + t

  render: =>
    info = this.model.currentLevelInfo()
    if this.currentLevel != info.levelIndex
      this.model.trigger('change:level', info)
      this.audio.play() if info.running && this.currentLevel?
      this.currentLevel = info.levelIndex
    this.$('#round_time_left').text(this.formatTime(info.levelSecondsLeft))
    this.$('#round_time_left').toggleClass('running', info.running)
    this.$('#game_time').text(this.formatTime(info.gameSeconds))
    this
