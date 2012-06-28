# some articles, guides, posts
class Category < ActiveRecord::Base
  def self.refresh(id, name="", descr="")
    fail unless id
    cat = self.find id.to_i
    cat.name, cat.description = name, descr
    cat.save
  end
end

class Guide < ActiveRecord::Base
  def category
    Category.find self.category_id
  end
  def page_views
    PageView.where(guide_id: self.id).size
  end
end

# the 5 classes, as reference for some skills etc
class PlayerClass < ActiveRecord::Base
end

# big collection of skills, stats and more
class Skill < ActiveRecord::Base
end

class Rune < ActiveRecord::Base
end

class Attribute < ActiveRecord::Base
end

# statistic tables
class PageView < ActiveRecord::Base
end

class BattleTag < ActiveRecord::Base
end