# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require backbone/main

initializeLocale()

game = new Clock.Models.Game({ id: 1 })
game.fetch()

window.game = game
window.undoManager = new Clock.Models.UndoManager

timerView = new Clock.Views.TimerView({ model: game })
infoView = new Clock.Views.InfoView({ model: game })
levelsView = new Clock.Views.LevelsView({ game: game })
addLevelsView = new Clock.Views.AddLevelView({ model: game.levels })
payoutsView = new Clock.Views.PayoutsView({ game: game })
addPayoutView = new Clock.Views.AddPayoutView({ model: game.payouts })
playersView = new Clock.Views.PlayersView({ model: game })
addPlayerView = new Clock.Views.AddPlayerView({ model: game.players })
undoView = new Clock.Views.UndoView({ model: window.undoManager })
footerView = new Clock.Views.FooterView({ model: game })
