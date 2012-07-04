class window.Calc
  
  this.reduce = (enemy) ->
    (1 - Player.relativeArmor(enemy)) * 
    (1 - Player.relativeResist(enemy)) *
    (1 - Player.meleeReduce()) * 
    (1 - Player.eliteReduce()) * 
    (1 - Player.generalReduce()) *
    (1 - Player.meleeBonus())
    
  this.incomingDamage = (enemy) ->
    rawDamage = enemy.damage * Calc.reduce(enemy) * (1 - Player.dodge())
    avBlock = Player.blockChance() * Player.blockAverage()
    if (rawDamage <= avBlock) then 1 else rawDamage - avBlock
  
  this.healPerSecond = ->
    Player.dps() * Player.lifeLeech() +
    Player.attackSpeed() * Player.lifePerHit() * 0.7 +#inferno
    Player.lifePerSecond()
  
  this.effectiveLifeTime = (enemy) ->
    inc = Calc.incomingDamage(enemy)
    heal = Calc.healPerSecond()
    atkSpeed = 1.5 #hardcoded for enemys for now
    heal = heal * atkSpeed
    differencePerCycle = inc - heal
    differencePerCycle = 1.0 if differencePerCycle <= 1
    Player.health() / differencePerCycle * 1.4 #normalize to simulated results

  this.eltValues = ->
    act1: Calc.effectiveLifeTime(Enemy.Act1)
    act2: Calc.effectiveLifeTime(Enemy.Act2)
    act3: Calc.effectiveLifeTime(Enemy.Act3)
    act4: Calc.effectiveLifeTime(Enemy.Act4)
