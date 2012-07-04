class window.Storage
  
  this.fieldNames = ->
    [
      "weaponDamageMin",
      "weaponDamageMax",
      "weaponDamageMinOffhand",
      "weaponDamageMaxOffhand",
      "bonusDamageMin",
      "bonusDamageMax",
      "mainAttribute",
      "attacksPerSecond",
      "critChance",
      "critDamageBonus",
      "armor",
      "resist",
      "dodge",
      "blockChance",
      "blockValueMin",
      "blockValueMax",
      "generalReduction",
      "eliteReduction",
      "meleeReduction",
      "vitality",
      "lifeBonus",
      "lifePerSecond",
      "lifeLeech",
      "lifePerHit"
    ]
  
  this.collectDataFromPage = ->
    fieldNames = Storage.fieldNames()
    resultHash = {}
    for name in fieldNames
      resultHash[name] = $("#"+name).val()
    resultHash
  
  this.save = ->
    dataHash = Storage.collectDataFromPage()
    $.cookie("character_cache", JSON.stringify(dataHash), {expires: 365})
    
  this.readDataFromCookie = ->
    JSON.parse($.cookie("character_cache"))
    
  this.load = ->
    dataHash = Storage.readDataFromCookie()
    for name, value of dataHash
      $("#"+name).val value
    Widgets.updateAll()
