@testable import GildedRose
import XCTest

class GildedRoseTests: XCTestCase {

    func testItemName() {
        let items = [Item(name: "foo", sellIn: 0, quality: 0)]
        let app = GildedRose(items: items)
        app.updateQuality()
        XCTAssertEqual(app.items[0].name, "foo")
    }

    func testQualityDegradesTwiceAsFastOnceTheSellDateHasPassed() {
        let originalQuality = 10
        let items = [Item(name: "Potato", sellIn: -1, quality: originalQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, originalQuality - 2)
    }

    func testQualityIsNeverNegative() {
        let minimumQuality = 0
        let items = [Item(name: "Potato", sellIn: 0, quality: minimumQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, minimumQuality)
    }

    func testAgedBrieIncreasesInQuality() {
        let originalQuality = 0
        let items = [Item(name: "Aged Brie", sellIn: 0, quality: originalQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertTrue(app.items[0].quality > originalQuality)
    }

    func testQualityIsNeverMoreThan50() {
        let maximumQuality = 50
        let items = [Item(name: "Aged Brie", sellIn: 0, quality: maximumQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, maximumQuality)
    }

    func testLegendaryItemNeverHasToBeSold() {
        let originalSellIn = -1
        let items = [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: originalSellIn, quality: 80)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].sellIn, originalSellIn)
    }

    func testLegendaryItemQualityNeverDecreases() {
        let items = [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, 80)
    }

    func testBackStagePassesQualityIncreaseNormallyBedore10Days() {
        let sellIn = 15
        let originalQuality = 10
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: sellIn, quality: originalQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, originalQuality + 1)
    }

    func testBackStagePassesQualityIncreaseByTwoWithin10Days() {
        let sellIn = 10
        let originalQuality = 10
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: sellIn, quality: originalQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, originalQuality + 2)
    }

    func testBackStagePassesQualityIncreaseByThreeWithin5Days() {
        let sellIn = 5
        let originalQuality = 10
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: sellIn, quality: originalQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, originalQuality + 3)
    }

    func testBackStagePassesQualityDropsToZeroAfterConcert() {
        let sellIn = -1
        let originalQuality = 10
        let items = [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: sellIn, quality: originalQuality)]
        let app = GildedRose(items: items)

        app.updateQuality()

        XCTAssertEqual(app.items[0].quality, 0)
    }
}
