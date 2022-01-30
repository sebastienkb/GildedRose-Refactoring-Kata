public class GildedRose {
    let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }

    public func updateQuality() {
        for i in 0 ..< items.count {
            if items[i].name != "Aged Brie" && items[i].name != "Backstage passes to a TAFKAL80ETC concert" {
                if items[i].quality > 0 {
                    if items[i].name != "Sulfuras, Hand of Ragnaros" {
                        items[i].quality = items[i].quality - 1
                    }
                }
            } else {
                if items[i].quality < 50 {
                    items[i].quality = items[i].quality + 1

                    if items[i].name == "Backstage passes to a TAFKAL80ETC concert" {
                        if items[i].sellIn < 11 {
                            if items[i].quality < 50 {
                                items[i].quality = items[i].quality + 1
                            }
                        }
                        
                        if items[i].sellIn < 6 {
                            if items[i].quality < 50 {
                                items[i].quality = items[i].quality + 1
                            }
                        }
                    }
                }
            }

            if items[i].name != "Sulfuras, Hand of Ragnaros" {
                items[i].sellIn = items[i].sellIn - 1
            }

            if items[i].sellIn < 0 {
                if items[i].name != "Aged Brie" {
                    if items[i].name != "Backstage passes to a TAFKAL80ETC concert" {
                        if items[i].quality > 0 {
                            if items[i].name != "Sulfuras, Hand of Ragnaros" {
                                items[i].quality = items[i].quality - 1
                            }
                        }
                    } else {
                        items[i].quality = items[i].quality - items[i].quality
                    }
                } else {
                    if items[i].quality < 50 {
                        items[i].quality = items[i].quality + 1
                    }
                }
            }
        }
    }
}

private extension Item {

    var qualityEvolution: QualityEvolution { QualityEvolution(for: name) }

    func updateQuality() {
        switch qualityEvolution {

        case .decreasing:
            sellIn = sellIn - 1
            let multiplier = sellIn < 0 ? 2 : 1
            quality = max(Constants.minimumQuality, quality - 1 * multiplier)

        case .increasing:
            sellIn = sellIn - 1
            quality = min(Constants.maximumRegularQuality, quality + 1)

        case .pumpAndDump:
            sellIn = sellIn - 1
            switch sellIn {
            case ..<(-1):
                quality = Constants.minimumQuality
            case 0...5:
                quality = min(Constants.maximumRegularQuality, quality + 3)
            case 6...10:
                quality = min(Constants.maximumRegularQuality, quality + 2)
            default:
                quality = min(Constants.maximumRegularQuality, quality + 1)
            }

        case .unaffected:
            quality = Constants.maximumLegendaryQuality // `break` would also be valid because its init contains 80; this would be a post-init corrective measure
        }
    }

    enum Constants {
        static let minimumQuality = 0
        static let maximumRegularQuality = 50
        static let maximumLegendaryQuality = 80
    }
}

private enum QualityEvolution {

    case decreasing // decreases over time
    case increasing // increases over time
    case pumpAndDump // increases sharply until its sellIn value, then drops to 0
    case unaffected // doesn't change

    init(for itemName: String) {
        // rules may be adapted depending if input is error-prone or not: case-insensitive, trim whitespaces, regex, ...
        if itemName.starts(with: "Sulfuras") {
            self = .unaffected
        } else if itemName == "Aged Brie" {
            self = .increasing
        } else if itemName.starts(with: "Backstage pass") {
            self = .pumpAndDump
        } else {
            self = .decreasing
        }
    }
}
