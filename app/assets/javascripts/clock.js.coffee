# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require backbone/main

I18n.locale = $('body').attr('lang')
I18n.fallbacks = true

# https://github.com/fnando/i18n-js/issues/80
I18n.translations[I18n.locale] or= {}

game = new Clock.Models.Game({ id: 1 })
game.fetch({
  error: =>
    game.reset()
    game.save()
})

window.game = game
window.undoManager = new Clock.Models.UndoManager

timerView = new Clock.Views.TimerView { model: game }
infoView = new Clock.Views.InfoView { model: game }
levelsView = new Clock.Views.LevelsView { game: game }
addLevelsView = new Clock.Views.AddLevelView { model: game.levels }
payoutsView = new Clock.Views.PayoutsView { game: game }
addPayoutView = new Clock.Views.AddPayoutView { model: game.payouts }
playersView = new Clock.Views.PlayersView { model: game }
addPlayerView = new Clock.Views.AddPlayerView { model: game.players }
undoView = new Clock.Views.UndoView { model: window.undoManager }
headerView = new Clock.Views.HeaderView { model: game }
footerView = new Clock.Views.FooterView { model: game }

window.addthis_config = {
  ui_language: I18n.locale
  ui_click: true
  data_track_clickback: false
}
