$ ->
    setAllPredefs()
    updateOnChange()

################################################
### set some predefined values #################
################################################
setOffensePredefs = ->
  $('#weaponDamageMin').val 1
  $('#weaponDamageMax').val 1
  $('#mainAttribute').val 187
  $('#attacksPerSecond').val 1.0
  $('#critChance').val 5.0
  $('#critDamage').val 50.0

setDefensePredefs = ->
  $('#armor').val 67
  $('#resist').val 6.7
  $('#dodge').val 12.2
  $('#blockChance').val 0
  $('#blockValueMin').val 0
  $('#blockValueMax').val 0
  $('#generalReduction').val 0
  $('#eliteReduction').val 0
  $('#meleeReduction').val 0

setLifePredefs = ->
  $('#vitality').val 127
  $('#lifeBonus').val 0.0
  $('#lifePerSecond').val 0
  $('#lifeLeech').val 0.0
  $('#lifePerHit').val 0

Act1 = 
  enemyDamage: 100000
  enemyLevel: 61

Act2 = 
  enemyDamage: 200000
  enemyLevel: 62

Act3 = 
  enemyDamage: 300000
  enemyLevel: 63

Act4 = 
  enemyDamage: 400000
  enemyLevel: 63

################################################
### getter methods for the categorywidgets #####
################################################
getOffenseValues = ->
  weaponDamage = (parseInt($('#weaponDamageMin').val()) + parseInt($('#weaponDamageMax').val())) / 2.0
  damage = weaponDamage * (1 + parseInt($('#mainAttribute').val()) * 0.01)
  critDamage = (1 + parseFloat($('#critDamage').val()) / 100) * damage
  attackSpeed = parseFloat($('#attacksPerSecond').val())
  averageDamage = damage + (critDamage - damage) * parseFloat($('#critChance').val()) / 100
  { 
    damage: damage
    critDamage: critDamage
    averageDamage: averageDamage
    attackSpeed: attackSpeed
    damagePerSecond: averageDamage * attackSpeed
  }

getDefenseValues = ->
  armor = parseInt($('#armor').val())
  resist = parseInt($('#resist').val())
  dodge = parseFloat($('#dodge').val())
  health = (parseInt($('#vitality').val()) * 35 * (1 + parseInt($('#lifeBonus').val())))
  generalReduce = parseFloat($('#generalReduction').val()) / 100
  eliteReduce = parseFloat($('#eliteReduction').val()) / 100
  meleeReduce = parseFloat($('#meleeReduction').val()) / 100
  meleeBonus = if $('#melee').val() == "0" then 0.0 else 0.3 
  relativeArmor = (act) -> armor / (armor + 50.0 * act.enemyLevel)
  relativeResist = (act) -> resist / (resist + 5.0 * act.enemyLevel)
  relativeEhp = (act) ->
    health * 
    (1 + relativeArmor(act)) * 
    (1 + relativeResist(act)) * 
    (1 + dodge / 100) *
    (1 + generalReduce) *
    (1 + eliteReduce) *
    (1 + meleeReduce) *
    (1 + meleeBonus)
  {
    act1: relativeEhp(Act1)
    act2: relativeEhp(Act2)
    act3: relativeEhp(Act3)
    act4: relativeEhp(Act4)
  }

getSurvivalValues = ->
  
  # collect informations
  armor = parseInt($('#armor').val())
  resist = parseInt($('#resist').val())
  dodge = parseFloat($('#dodge').val())
  health = (parseInt($('#vitality').val()) * 35 * (1 + parseInt($('#lifeBonus').val()) / 100.0))
  generalReduce = parseFloat($('#generalReduction').val()) / 100
  eliteReduce = parseFloat($('#eliteReduction').val()) / 100
  meleeReduce = parseFloat($('#meleeReduction').val()) / 100
  meleeBonus = if $('#melee').val() == "0" then 0.0 else 0.3 
  block = (parseInt($('#blockValueMin').val()) + parseInt($('#blockValueMax').val())) / 2.0 * 
          parseFloat($('#blockChance').val()) / 100.0
  offense = getOffenseValues()
  lifePerHit = parseInt($('#lifePerHit').val())
  lifeLeech = parseFloat($('#lifeLeech').val())
  lifePerSecond = parseInt($('#lifePerSecond').val())
  
  # calculation helper methods
  relativeArmor = (act) -> armor / (armor + 50.0 * act.enemyLevel)
  relativeResist = (act) -> resist / (resist + 5.0 * act.enemyLevel)
  incomingDamage = (act) ->
    act.enemyDamage * 
    (1 - meleeReduce) * (1 - eliteReduce) * (1 - generalReduce) *
    (1 - dodge / 100.0) * (1 - meleeBonus) *
    (1 - relativeArmor(act)) * (1 - relativeResist(act)) - 
    block
  lifeGainPerSecond = ->
    lifePerSecond +
    lifePerHit * offense.attackSpeed * 0.7 + #static modifier until API releases
    offense.damagePerSecond * (lifeLeech / 100.0) * 0.2 #inferno malus
  
  # ELT-calculation
  effectiveLifeTime = (act) ->
    inc = incomingDamage(act)
    gain = lifeGainPerSecond()
    inc = 0.0 if inc < 0.0
    inc = 1.0 if inc == 0.0 && gain == 0.0
    differencePerSecond = inc - gain
    differencePerSecond = 1 if differencePerSecond < 0
    health / (differencePerSecond)
  
  # results
  {
    act1: effectiveLifeTime(Act1)
    act2: effectiveLifeTime(Act2)
    act3: effectiveLifeTime(Act3)
    act4: effectiveLifeTime(Act4)
  }

################################################
### ui-updating methods ########################
################################################
updateDamageWidget = ->
  vals = getOffenseValues()
  $('#resultDamage').text vals.damage.toFixed(2)
  $('#resultCritDamage').text vals.critDamage.toFixed(2)
  $('#resultAverageDamage').text vals.averageDamage.toFixed(2)
  $('#resultDamagePerSecond').text vals.damagePerSecond.toFixed(2)

updateEhpWidget = ->
  vals = getDefenseValues()
  $('#ehpAct1').text vals.act1.toFixed(2)
  $('#ehpAct2').text vals.act2.toFixed(2)
  $('#ehpAct3').text vals.act3.toFixed(2)
  $('#ehpAct4').text vals.act4.toFixed(2)

updateEltWidget = ->
  vals = getSurvivalValues()
  $('#eltAct1').text vals.act1.toFixed(2) + " Sekunden"
  $('#eltAct2').text vals.act2.toFixed(2) + " Sekunden"
  $('#eltAct3').text vals.act3.toFixed(2) + " Sekunden"
  $('#eltAct4').text vals.act4.toFixed(2) + " Sekunden"

################################################
### main methods ###############################
################################################
setAllPredefs = ->
  setOffensePredefs()
  setDefensePredefs()
  setLifePredefs()

updateAll = ->
  updateDamageWidget()
  updateEhpWidget()
  updateEltWidget()

updateOnChange = ->
  updateAll()
  $('input').change -> updateAll()
  $('select').change -> updateAll()
