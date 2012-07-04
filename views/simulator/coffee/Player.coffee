class window.Player
  ###################################
  ### Offense values
  ###################################
  this.mainAttribute = -> parseInt($('#mainAttribute').val())
  this.weaponDamage = -> (parseInt($('#weaponDamageMin').val()) + parseInt($('#weaponDamageMax').val()) )/ 2.0
  this.weaponDamageOffhand = -> (parseInt($('#weaponDamageMinOffhand').val()) + parseInt($('#weaponDamageMaxOffhand').val()) ) / 2.0
  this.bonusDamage = -> (parseInt($('#bonusDamageMin').val()) + parseInt($('#bonusDamageMax').val())) / 2.0
  this.damageMainhand = -> (Player.weaponDamage() + Player.bonusDamage()) * (1 + Player.mainAttribute() / 100.0)
  this.damageOffhand = -> (Player.weaponDamageOffhand() + Player.bonusDamage()) * (1 + Player.mainAttribute() / 100.0)
  this.critDamageBonus = -> parseFloat($('#critDamageBonus').val()) / 100.0
  this.critChance = -> parseFloat($('#critChance').val()) / 100.0
  this.attackSpeed = -> parseFloat($('#attacksPerSecond').val())
  this.isDualwield = -> if Player.weaponDamageOffhand() != 0 then true else false
  this.isShield = -> if Player.blockChance() == 0.0 then false else true
  this.damage = -> if (Player.isDualwield()) then (Player.damageMainhand() + Player.damageOffhand()) / 2.0 else Player.damageMainhand()
  this.critDamage = -> Player.damage() * (1 + Player.critDamageBonus())
  this.averageDamage = -> Player.damage() * (1 - Player.critChance()) + Player.critDamage() * Player.critChance()
  this.dps = -> Player.damage() * (1 + Player.critChance() * Player.critDamageBonus()) * Player.attackSpeed()
  this.getOffenseValues = ->
    { 
      damage: Player.damage()
      critDamage: Player.critDamage()
      attackSpeed: Player.attackSpeed()
      averageDamage: Player.averageDamage()
      damagePerSecond: Player.dps()
    }
  
  #####################################
  ### Defense Values
  #####################################
  this.armor = -> parseInt($('#armor').val())
  this.resist = -> parseInt($('#resist').val())
  this.dodge = -> parseFloat($('#dodge').val()) / 100.0
  this.vitality = -> parseInt($('#vitality').val())
  this.healthBonus = -> parseInt($('#lifeBonus').val()) / 100.0 + 1
  this.health = -> Player.vitality() * 35 * Player.healthBonus()
  this.blockMin = -> parseInt($('#blockValueMin').val())
  this.blockMax = -> parseInt($('#blockValueMax').val())
  this.blockAverage = -> (Player.blockMin() + Player.blockMax()) / 2.0 
  this.blockChance = -> parseFloat($('#blockChance').val()) / 100.0
  this.generalReduce = -> parseFloat($('#generalReduction').val()) / 100.0
  this.eliteReduce = -> parseFloat($('#eliteReduction').val()) / 100.0
  this.meleeReduce = -> parseFloat($('#meleeReduction').val()) / 100.0
  this.meleeBonus = -> if $('#melee').val() == "0" then 0.0 else 0.3
  this.relativeArmor = (enemy) -> Player.armor() / (Player.armor() + 50.0 * enemy.level)
  this.relativeResist = (enemy) -> Player.resist() / (Player.resist() + 5.0 * enemy.level)
  this.relativeEhp = (enemy) ->
    Player.health() * 
    (1 + Player.relativeArmor(enemy)) * 
    (1 + Player.relativeResist(enemy)) * 
    (1 + Player.generalReduce()) *
    (1 + Player.eliteReduce()) *
    (1 + Player.meleeReduce()) *
    (1 + Player.meleeBonus())
    
  this.getDefenseValues = -> 
    {
      act1: Player.relativeEhp(Enemy.Act1)
      act2: Player.relativeEhp(Enemy.Act2)
      act3: Player.relativeEhp(Enemy.Act3)
      act4: Player.relativeEhp(Enemy.Act4)
    }

  ##########################################
  ### Life gain values
  ##########################################
  this.lifePerHit = -> parseInt($('#lifePerHit').val())
  this.lifeLeech = -> parseFloat($('#lifeLeech').val()) / 100.0
  this.lifePerSecond = -> parseInt($('#lifePerSecond').val())


  ##########################################
  ### Shorthand Summarys
  ##########################################
  this.offense = ->
    damage: Player.damage()
    critDamage: Player.damage() * (1 + Player.critDamage())
    attackSpeed: Player.attackSpeed()
    averageDamage: Player.averageDamage()
    damagePerSecond: Player.dps()
  
  this.defense = (enemyDamage) ->
    health = Player.health()
    relativeArmor: Player.relativeArmor(enemyDamage)
    relativeResist: Player.relativeResist(enemyDamage)
    dodge: Player.dodge() / 100.0
    generalReduce: Player.generalReduce()
    eliteReduce: Player.eliteReduce()
    meleeReduce: Player.meleeReduce()
    meleeBonus: Player.meleeBonus()
    blockMin: Player.blockMin()
    blockMax: Player.blockMax()
    blockChance: Player.blockChance()
    
  this.life = ->
    lifePerHit: Player.lifePerHit()
    lifeLeech: Player.lifeLeech()
    lifePerSecond: Player.lifePerSecond()
  
