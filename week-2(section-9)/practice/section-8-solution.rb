require_relative './section-8-provided'

class Character
  def initialize hp
    @hp = hp
  end

  def resolve_encounter enc
    if !is_dead?
      play_out_encounter enc
    end
  end

  def is_dead?
    @hp <= 0
  end

  def damage dam
    @hp = @hp - dam
  end

  private

  def play_out_encounter enc
    raise "You should implement `play_out_encounter` for you Character subclass"
  end
end

class Knight < Character
  def initialize(hp, ap)
    super hp
    @ap = ap
  end

  def to_s
    "HP: " + @hp.to_s + " AP: " + @ap.to_s
  end

  ## YOUR CODE HERE
  def play_out_encounter enc
    enc.encounter_knight self
  end

  def damage dam
    if @ap == 0
      super dam
    elsif @ap > dam
      @ap = @ap - dam
    else 
      super dam - @ap
      @ap = 0
    end
  end

  def drink_potion potion
    @hp = @hp + potion.hp
  end

  def armor_up armor
    @ap = @ap + armor.ap
  end
end

class Wizard < Character
  def initialize(hp, mp)
    super hp
    @mp = mp
  end

  def to_s
    "HP: " + @hp.to_s + " MP: " + @mp.to_s
  end

  ## YOUR CODE HERE
  def play_out_encounter enc
    enc.encounter_wizard self
  end

  def use_spell spell_mp
    @mp = @mp - spell_mp
  end

  def try_fly_over_trap trap
    if @mp > 0
      self.use_spell 1
    else
      self.damage trap.dam
    end
  end

  def fight_monster monster
    if @mp >= monster.hp
      mana_needed_to_kill_a_monster = monster.hp
      self.use_spell mana_needed_to_kill_a_monster
    else
      # wizard couldn't kill a monster, so monster killed him
      @hp = 0
    end
  end

  def drink_potion potion
    @hp = @hp + potion.hp
    @mp = @mp + potion.mp
  end
end

class FloorTrap < Encounter
  attr_reader :dam

  def initialize dam
    @dam = dam
  end

  def to_s
    "A deadly floor trap dealing " + @dam.to_s + " point(s) of damage lies ahead!"
  end

  ## YOUR CODE HERE
  def encounter_knight knight
    knight.damage @dam
  end

  def encounter_wizard wizard
    wizard.try_fly_over_trap self
  end
end

class Monster < Encounter
  attr_reader :dam, :hp

  def initialize(dam, hp)
    @dam = dam
    @hp = hp
  end

  def to_s
    "A horrible monster lurks in the shadows ahead. It can attack for " +
        @dam.to_s + " point(s) of damage and has " +
        @hp.to_s + " hitpoint(s)."
  end

  ## YOUR CODE HERE
  def encounter_knight knight
    knight.damage @dam
  end

  def encounter_wizard wizard
    wizard.fight_monster self
  end
end

class Potion < Encounter
  attr_reader :hp, :mp

  def initialize(hp, mp)
    @hp = hp
    @mp = mp
  end

  def to_s
    "There is a potion here that can restore " + @hp.to_s +
        " hitpoint(s) and " + @mp.to_s + " mana point(s)."
  end

  ## YOUR CODE HERE
  def encounter_knight knight
    knight.drink_potion self
  end

  def encounter_wizard wizard
    wizard.drink_potion self
  end
end

class Armor < Encounter
  attr_reader :ap

  def initialize ap
    @ap = ap
  end

  def to_s
    "A shiny piece of armor, rated for " + @ap.to_s +
        " AP, is gathering dust in an alcove!"
  end

  ## YOUR CODE HERE
  def encounter_knight knight
    knight.armor_up self
  end

  def encounter_wizard wizard
    # nothing to do here, just processing wizard to the next step
    wizard
  end
end

sir_foldalot = Knight.new(15, 3)
knight_of_lambda_calculus = Knight.new(10, 10)
sir_pinin_for_the_fjords = Knight.new(0, 15)
alonzo_the_wise = Wizard.new(3, 50)
dhuwe_the_unready = Wizard.new(8, 5)

if __FILE__ == $0
  Adventure.new(Stdout.new, sir_foldalot,
    [Monster.new(1, 1),
    FloorTrap.new(3),
    Monster.new(5, 3),
    Potion.new(5, 5),
    Monster.new(1, 15),
    Armor.new(10),
    FloorTrap.new(5),
    Monster.new(10, 10)]).play_out
end