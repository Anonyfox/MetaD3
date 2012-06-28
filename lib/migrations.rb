class AddTables < ActiveRecord::Migration
  def self.up
    
    create_table :categories do |t|
      t.string :name
      t.text :description
    end
    
    create_table :guides do |t|
      t.string :title
      t.integer :category_id
      t.text :text
      t.timestamps
    end
    
    create_table :player_classes do |t|
      t.string :name
      t.string :main_attribute
      t.string :resource_name
      t.boolean :melee
    end
    
    create_table :skills do |t|
      t.string :name
      t.integer :blizzard_id
      t.integer :player_class_id
      t.string :original_text
      t.string :type # 'damage' / 'buff' / 'debuff' / 'heal' / 'cc'
      t.integer :relative_value # 120 PERCENT damage e.g.
      t.boolean :depends_on_dps
      t.boolean :depends_on_damage
      t.boolean :aoe
      t.integer :rating # from 0 to 10 points, meant is the strength/usability of the spell
      t.string :comment
    end
    
    create_table :runes do |t|
      t.integer :skill_id
      t.string :name
      t.string :original_text
      t.string :comment
      t.string :type # 'damage' / 'buff' / 'debuff' / 'heal' / 'cc'
      t.integer :relative_value # 120 PERCENT damage e.g.
      t.boolean :depends_on_dps
      t.boolean :depends_on_damage
      t.boolean :aoe
      t.integer :rating # from 0 to 10 points, meant is the strength/usability of the spell
    end
    
    create_table :attributes do |t|
      t.string :name
      t.text :description
    end
    
    create_table :page_views do |t|
      t.integer :guide_id
      t.string :visitor_ip
      t.string :browser
      t.timestamps
    end
    
    create_table :battle_tags do |t|
      t.string :full
      t.string :name
      t.string :number
      t.text :account_information # the stuff from blizzards API in JSON format
      t.timestamps
    end
    
    create_table :visitor_characters do |t|
      t.string :class
      t.integer :battle_tag_id
      t.integer :hero_number
      t.text :hero_information #stuff from Blizz API in JSON
    end
  end

  def self.down
    drop_table :page_views
    drop_table :battle_tags
    drop_table :visitor_characters
  end
end