class window.Simulation
  this.getParams = ->
    act = parseInt($('#simAct').val())
    enemy = Enemy.Act1 if act == 1
    enemy = Enemy.Act2 if act == 2
    enemy = Enemy.Act3 if act == 3
    enemy = Enemy.Act4 if act == 4
    {
      accuracy: parseInt($('#simAccuracy').val())
      enemy: enemy
      attackSpeed: parseFloat($('#simSpeed').val())
    }
  
  this.showResults = (results) ->
    rCycles  = "<tr><td>Anzahl Durchl&auml;ufe:</td><td>"+results.cycles+"</td></tr>"
    rAverage = "<tr><td>&#216; &uuml;berlebte Treffer: </td><td>"+results.hitsTilDeath.toFixed(2)+"</td></tr>"
    rMinimal = "<tr><td>minimal &uuml;berlebte Treffer:</td><td>"+results.minHitsTaken+"</td></tr>"
    rMaximal = "<tr><td>maximal &uuml;berlebte Treffer:</td><td>"+results.maxHitsTaken+"</td></tr>"
    rDodge = "<tr><td>&#216; ausgewichene Angriffe:</td><td>"+(results.dodgeChance * 100).toFixed(2)+"%</td></tr>"
    rBlock = "<tr><td>&#216; geblockte Angriffe:</td><td>"+(results.blockedHits * 100).toFixed(2)+"%</td></tr>"
    rHeal = "<tr><td>&#216; Heilung pro Kampf:</td><td>"+results.healPerCycle.toFixed(2)+" HP</td></tr>"
    rTime = "<tr><td>&#216; Lebenszeit pro Kampf:</td><td>"+results.secondsSurvived.toFixed(2)+" Sekunden</td></tr>"
    
    $('#simResult').html(
      "<p><b>Ergebnisse:</b></p>
      <fieldset><legend>&Uuml;bersicht</legend>
        <table>
          <tr>
            <td>Durchl&auml;ufe:</td><td>#{results.cycles}</td>
            <td>Schaden pro Sekunde (DPS):</td><td>#{Player.dps().toFixed(2)}</td>
          </tr>
          <tr>
            <td>&#216; &uuml;berlebte Treffer: </td><td>#{results.hitsTilDeath.toFixed(2)}</td>
            <td>Lebenspunkte:</td><td>#{results.health.toFixed(0)}</td>
          </tr>
          <tr>
            <td>&#216; Lebenszeit pro Kampf:</td><td>#{results.secondsSurvived.toFixed(2)} Sekunden</td>
            <td></td><td></td>
          </tr>
          <tr>
            <td>&#216; Heilung pro Kampf:</td><td>#{results.healPerCycle.toFixed(2)} HP</td>
            <td>&#216; Heilung pro Sekunde (HPS)</td><td>#{results.hps.toFixed(2)}</td>
          </tr>
        </table>
      </fieldset>
      <fieldset><legend>&Uumlberlebte Treffer &amp; Ausweichen - Details</legend>
        <table>
          <tr>
            <td>&#216; &uuml;berlebte Treffer: </td><td>#{results.hitsTilDeath.toFixed(2)}</td>
            <td>Gegnerschaden (voll):</td><td>#{results.enemyDamage}</td>
            <td>&#216; ausgewichene Angriffe:</td><td>#{(results.dodgeChance * 100).toFixed(2)}%</td>
          </tr>
          <tr>
            <td>minimal &uuml;berlebte Treffer:</td><td>#{results.minHitsTaken}</td>
            <td>Gegnerlevel:</td><td>#{results.enemyLevel}</td>
            <td>minimal ausgewichene Angriffe:</td><td>#{results.minDodges}</td>
          </tr>
          <tr>
            <td>maximal &uuml;berlebte Treffer:</td><td>#{results.maxHitsTaken}</td>
            <td>Gegnerschaden (reduziert):</td><td>#{results.reducedDamage.toFixed(2)}</td>
            <td>maximal ausgewichene Angriffe:</td><td>#{results.maxDodges}</td> 
          </tr>
        </table>
      </fieldset>
      <fieldset><legend>geblockte Angriffe - Details</legend>
        <table>
          <tr>
            <td>&#216; geblockte Angriffe:</td><td>#{(results.blockChance * 100).toFixed(2)}%</td>
            <td>&#216; Blockwert:</td><td>#{results.blockValue}</td>
          </tr>
          <tr>
            <td>minimal geblockte Angriffe:</td><td>#{results.minBlocks}</td>
            <td>Restschaden nach Block:</td><td>#{results.damageAfterBlock.toFixed(0)}</td>
          </tr>
          <tr>
            <td>maximal geblockte Angriffe:</td><td>#{results.maxBlocks}</td>
            <td>Schadensverringerung bei Block:</td><td>#{results.blockedDamageRelative.toFixed(2)}%</td>
          </tr>
        </table>
      </fieldset>
      "
    )
  
  this.run = ->
    $('#simResult').html("")
    params = Simulation.getParams()
    results = Simulation.execute(params.accuracy, params.enemy, params.attackSpeed)
    Simulation.showResults(results)  
  
  this.testRun = ->
    console.log(Simulation.execute(100000, Enemy.Act1, 1.5))
  
  this.execute = (accuracy, enemy, enemyAttackSpeed) ->
    # some shorthand variables
    damage = enemy.damage
    reduce = Calc.reduce(enemy)
    hps = Calc.healPerSecond()
    health = Player.health()
    dodge = Player.dodge()
    blockChance = Player.blockChance()
    blockValue = Player.blockAverage()
    attackspeed = enemyAttackSpeed
    
    # counter for the cycles
    sumBlocks = 0.0
    maxBlocks = 0
    minBlocks = 999999999999
    sumDodges = 0.0
    maxDodges = 0
    minDodges = 999999999999
    sumHitsTaken = 0.0
    sumHitsTotal = 0.0
    maxHitsTaken = 1
    minHitsTaken = 999999999999
    healthRestored = 0.0
    cycles = 0.0
    
    while cycles < accuracy
      hp = health
      hitsCurrent = 0
      dodgesCurrent = 0
      blocksCurrent = 0
      while hp > 0
        if (Math.random() < dodge) # dodged 
          sumDodges += 1
          dodgesCurrent += 1  
        else # reduce normally
          sumHitsTaken += 1
          inc = damage * reduce
          if (Math.random() < blockChance) #blocked
            sumBlocks += 1
            blocksCurrent += 1
            inc -= blockValue
            inc = 0 if inc < 0
          hp -= inc
        sumHitsTotal += 1
        hitsCurrent += 1
        hp += hps * attackspeed
        healthRestored += hps * attackspeed
        hp = health if hp > health
      cycles += 1
      maxHitsTaken = hitsCurrent if maxHitsTaken < hitsCurrent
      minHitsTaken = hitsCurrent if minHitsTaken > hitsCurrent
      maxDodges = dodgesCurrent if maxDodges < dodgesCurrent
      minDodges = dodgesCurrent if minDodges > dodgesCurrent
      maxBlocks = blocksCurrent if maxBlocks < blocksCurrent
      minBlocks = blocksCurrent if minBlocks > blocksCurrent
    
    # return results
    damageAfterBlock = if (damage * reduce - blockValue < 0) then 0 else damage * reduce - blockValue
    {
      cycles: cycles
      
      dodgeChance: sumDodges / sumHitsTotal
      minDodges: minDodges
      maxDodges: maxDodges
      
      blockChance: sumBlocks / sumHitsTotal
      minBlocks: minBlocks
      maxBlocks: maxBlocks
      blockValue: blockValue
      damageAfterBlock: damageAfterBlock
      blockedDamageRelative: if (damageAfterBlock == 0) then 100 else (1 - (damageAfterBlock / (damage * reduce))) * 100
      
      hitsTilDeath: sumHitsTotal / cycles
      secondsSurvived: sumHitsTotal / cycles * attackspeed
      maxHitsTaken: maxHitsTaken
      minHitsTaken: minHitsTaken
      
      healPerCycle: healthRestored / cycles
      
      enemyDamage: enemy.damage
      enemyLevel: enemy.level
      reduce: reduce
      reducedDamage: damage * reduce
      
      hps: hps
      health: health
    }