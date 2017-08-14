def update_quality(items)
  QualityUpdater.new.update(items)
end

class QualityUpdater
  def update(items)
    items.each do |item|
      updater = determine_updater(item)
      updater.update(item)
    end
  end

  private

  def determine_updater(item)
    updater = UPDATER_FOR[item.name]
    updater.nil? ? StandardUpdater.new : updater
  end

  class StandardUpdater
    def update(item)
      update_quality(item)
      update_sell_in(item)
    end

    def update_quality(item)
      adjustment = item.sell_in <= 0 ? -2 : -1
      adjust_quality(item, adjustment)
    end

    def update_sell_in(item)
      item.sell_in -= 1
    end

    def adjust_quality(item, amount)
      item.quality += amount
      item.quality = 0 if item.quality < 0
      item.quality = 50 if item.quality > 50
    end
  end

  class AgedBrieUpdater < StandardUpdater
    def update_quality(item)
      adjust_quality(item, 1)
      adjust_quality(item, 1) if item.sell_in <= 0
    end
  end

  class BackstagePassUpdater < StandardUpdater
    def update_quality(item)
      return item.quality = 0 if item.sell_in <= 0
      adjust_quality(item, 1)
      adjust_quality(item, 1) if item.sell_in < 11
      adjust_quality(item, 1) if item.sell_in < 6
    end
  end

  class LegendaryUpdater
    def update(item)
    end
  end

  UPDATER_FOR = {
    'Aged Brie' => AgedBrieUpdater.new,
    'Backstage passes to a TAFKAL80ETC concert' => BackstagePassUpdater.new,
    'Sulfuras, Hand of Ragnaros' => LegendaryUpdater.new
  }
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

