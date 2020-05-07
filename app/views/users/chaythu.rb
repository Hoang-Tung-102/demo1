class Soldier
    attr_accessor :m_Code, :m_Attack, :m_Defend, 
      :m_Equipment, :m_Strength, :dead

    def initialize(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        @m_Code = m_Code
        @m_Attack = m_Attack
        @m_Defend = m_Defend
        @m_Equipment = m_Equipment
        @m_Strength = m_Strength
        @dead = false
    end

    def passive(rate)
        @m_Attack *= rate
        @m_Defend *= rate
    end

    def attackLeft
        @m_Attack -= 20
        @m_Defend -= 20
    end

    def dead?
        @dead
    end
end

class Valiant < Soldier
    def initialize(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        super(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        if @m_Equipment
            @m_Defend *= 2
        end
    end
end

class Archer < Soldier
    def initialize(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        super(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        if m_Equipment
            @m_Attack *= 1.5
        end
    end
end

class Knight < Soldier
    def initialize(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        super(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        if m_Equipment
            @m_Attack *= 3
            @m_Defend *= 3
        end
    end
end

class ArmyGeneral < Soldier
    attr_accessor :m_Experience

    def initialize(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength, m_Experience)
        super(m_Code, m_Attack, m_Defend, m_Equipment, m_Strength)
        @m_Experience = m_Experience
    end

    def experienceRate
        if @m_Experience <= 0
            0.5
        elsif @m_Experience <= 2
            0.8
        elsif @m_Experience <= 5
            1.5
        elsif @m_Experience > 5
            2
        end
    end
end

class Army
    attr_accessor :name, :armyGeneral, :soldiers

    def initialize(name, armyGeneral, soldiers)
        @name = name
        @armyGeneral = armyGeneral
        @soldiers = soldiers
        passive
    end

    def nextSoldier
        unless @soldiers.empty?
            @soldiers.shift
        else
          @armyGeneral
        end
    end

    private
    def passive
        @soldiers.each do |soldier|
            soldier.passive(@armyGeneral.experienceRate)
        end
    end
end

class Battle
    attr_accessor :teamA, :teamB

    def initialize(teamA, teamB)
        @teamA = teamA
        @teamB = teamB
    end

    def war
        soldierA = @teamA.nextSoldier
        soldierB = @teamB.nextSoldier
    while(!@teamA.armyGeneral.dead? && !@teamB.armyGeneral.dead?)
            attack(soldierA, soldierB)
            if soldierA.dead?
                puts "soldierA dead"
                soldierA = @teamA.nextSoldier
            else 
                puts "soldierB dead"
                soldierB = @teamB.nextSoldier
            end
        end
        if @teamA.armyGeneral.dead?
            puts "#{@teamB.name} win"
        else 
            puts "#{@teamA.name} win"
        end
    end
  
  private
    def attack(soldierA, soldierB)
        puts "#{soldierA.m_Code} - #{soldierB.m_Code} --- #{soldierA.m_Attack} - #{soldierB.m_Defend} --- #{soldierB.m_Attack} - #{soldierA.m_Defend} ---Strength: #{soldierA.m_Strength} - #{soldierB.m_Strength}"
        if soldierA.m_Attack > soldierB.m_Defend && soldierA.m_Defend > soldierB.m_Attack
            soldierB.dead = true
            soldierA.attackLeft
        elsif soldierB.m_Attack > soldierA.m_Defend && soldierB.m_Defend > soldierA.m_Attack
            soldierA.dead = true
            soldierB.attackLeft
        else
            if soldierA.m_Strength > soldierB.m_Strength
                soldierB.dead = true
              soldierA.attackLeft
            else
                soldierA.dead = true
              soldierB.attackLeft
            end
        end 
    end
end

class TheLastBattle
    def initialize
        team1 = buildTeam1
        team2 = buildTeam2
        battle = Battle.new(team1, team2)
        battle.war
    end

    def buildTeam1
        armyGeneral1 = ArmyGeneral.new("AG1", 70, 70, true, 30, 3.5)
        soldierV1 = Valiant.new("V001", 20, 10, true, 15)
        soldierA1 = Archer.new("A001", 10, 5, false, 14)
        soldierK1 = Knight.new("K001", 30, 35, true, 20)
        Army.new("Team A", armyGeneral1, [soldierV1, soldierA1, soldierK1])
    end

    def buildTeam2
        armyGeneral2 = ArmyGeneral.new("AG001", 100, 100, true, 50, 6)
        soldierV2 = Valiant.new("V002", 20, 30, true, 20)
        soldierK2 = Knight.new("K002", 50, 50, true, 30)
        Army.new("Team B", armyGeneral2, [soldierV2, soldierK2])
    end
end

TheLastBattle.new