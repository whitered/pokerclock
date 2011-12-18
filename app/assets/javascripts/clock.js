// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require backbone/main

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
