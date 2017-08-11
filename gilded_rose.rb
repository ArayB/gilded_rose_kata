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
    case item.name
    when 'Aged Brie'
      AgedBrieUpdater.new
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePassUpdater.new
    when 'Sulfuras, Hand of Ragnaros'
      LegendaryUpdater.new
    else
      StandardUpdater.new
    end
  end

  class StandardUpdater
    def update(item)
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            item.quality -= 1
          end
        end
      else
      end

      item.sell_in -= 1

      if item.sell_in < 0
        if item.quality > 0
          item.quality -= 1
        end
      end
    end
  end

  class AgedBrieUpdater
    def update(item)
      item.sell_in -= 1
      item.quality += 1 if item.quality < 50
      item.quality += 1 if item.quality < 50 && item.sell_in <= 0
    end
  end

  class BackstagePassUpdater
    def update(item)
      update_quality(item)
      item.sell_in -= 1
    end

    private

    def update_quality(item)
      if item.quality < 50
        item.quality += 1
        if item.sell_in < 11
          if item.quality < 50
            item.quality += 1
          end
        end
        if item.sell_in < 6
          if item.quality < 50
            item.quality += 1
          end
        end
      end

      item.quality = 0 if item.sell_in <= 0
    end
  end

  class LegendaryUpdater
    def update(item)
    end
  end
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

