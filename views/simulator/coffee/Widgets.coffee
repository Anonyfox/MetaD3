class window.Widgets
  this.updateDamage = ->
    vals = Player.getOffenseValues()
    $('#resultDamage').text vals.damage.toFixed(2)
    $('#resultCritDamage').text vals.critDamage.toFixed(2)
    $('#resultAverageDamage').text vals.averageDamage.toFixed(2)
    $('#resultDamagePerSecond').text vals.damagePerSecond.toFixed(2)
  
  this.updateEhp = ->
    vals = Player.getDefenseValues()
    $('#ehpAct1').text vals.act1.toFixed(2)
    $('#ehpAct2').text vals.act2.toFixed(2)
    $('#ehpAct3').text vals.act3.toFixed(2)
    $('#ehpAct4').text vals.act4.toFixed(2)
  
  this.updateElt = ->
    vals = Calc.eltValues()
    $('#eltAct1').text vals.act1.toFixed(2) + " Sekunden"
    $('#eltAct2').text vals.act2.toFixed(2) + " Sekunden"
    $('#eltAct3').text vals.act3.toFixed(2) + " Sekunden"
    $('#eltAct4').text vals.act4.toFixed(2) + " Sekunden"
  
  this.updateAll = ->
    Validator.correctInvalidValues()
    Widgets.updateDamage()
    Widgets.updateEhp()
    Widgets.updateElt()