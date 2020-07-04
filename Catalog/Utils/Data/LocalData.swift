import Foundation

public class LocalData {
  
  static func getCountries() -> [Country] {
    let countries = [
      Country(name: "albania", imgName: "albania"),
      Country(name: "andorra", imgName: "andorra"),
      Country(name: "armenia", imgName: "armenia"),
      Country(name: "austria", imgName: "austria"),
      Country(name: "azerbaijan", imgName: "azerbaijan"),
      Country(name: "belarus", imgName: "belarus"),
      Country(name: "belgium", imgName: "belgium"),
      Country(name: "bosnia_and_herzegovina", imgName: "bosnia_and_herzegovina"),
      Country(name: "bulgaria", imgName: "bulgaria"),
      Country(name: "croatia", imgName: "croatia"),
      Country(name: "cyprus", imgName: "cyprus"),
      Country(name: "czech_republic", imgName: "czech_republic"),
      Country(name: "denmark", imgName: "denmark"),
      Country(name: "estonia", imgName: "estonia"),
      Country(name: "finland", imgName: "finland"),
      Country(name: "france", imgName: "france"),
      Country(name: "georgia", imgName: "georgia"),
      Country(name: "germany", imgName: "germany"),
      Country(name: "greece", imgName: "greece"),
      Country(name: "hungary", imgName: "hungary"),
      Country(name: "iceland", imgName: "iceland"),
      Country(name: "ireland", imgName: "ireland"),
      Country(name: "italy", imgName: "italy"),
      Country(name: "kazakhstan", imgName: "kazakhstan"),
      Country(name: "kosovo", imgName: "kosovo"),
      Country(name: "latvia", imgName: "latvia"),
      Country(name: "liechtenstein", imgName: "liechtenstein"),
      Country(name: "lithuania", imgName: "lithuania"),
      Country(name: "luxembourg", imgName: "luxembourg"),
      Country(name: "macedonia", imgName: "macedonia"),
      Country(name: "malta", imgName: "malta"),
      Country(name: "moldova", imgName: "moldova"),
      Country(name: "monaco", imgName: "monaco"),
      Country(name: "montenegro", imgName: "montenegro"),
      Country(name: "netherlands", imgName: "netherlands"),
      Country(name: "norway", imgName: "norway"),
      Country(name: "poland", imgName: "poland"),
      Country(name: "portugal", imgName: "portugal"),
      Country(name: "romania", imgName: "romania"),
      Country(name: "russia", imgName: "russia"),
      Country(name: "san_marino", imgName: "san_marino"),
      Country(name: "scotland", imgName: "scotland"),
      Country(name: "serbia", imgName: "serbia"),
      Country(name: "slovakia", imgName: "slovakia"),
      Country(name: "slovenia", imgName: "slovenia"),
      Country(name: "spain", imgName: "spain"),
      Country(name: "sweden", imgName: "sweden"),
      Country(name: "switzerland", imgName: "switzerland"),
      Country(name: "turkey", imgName: "turkey"),
      Country(name: "ukraine", imgName: "ukraine"),
      Country(name: "united_kingdom", imgName: "united_kingdom")
    ]
    return countries
  }
  static func getRegions() -> [String] {
    let regionNames = [
      "region-picker.dolnoslaskie",
      "region-picker.kujawsko-pomorskie",
      "region-picker.lubelskie",
      "region-picker.lubuskie",
      "region-picker.lodzkie",
      "region-picker.malopolskie",
      "region-picker.mazowieckie",
      "region-picker.opolskie",
      "region-picker.podkarpackie",
      "region-picker.podlaskie",
      "region-picker.pomorskie",
      "region-picker.slaskie",
      "region-picker.swietokrzyskie",
      "region-picker.warminsko-mazurskie",
      "region-picker.wielkopolskie",
      "region-picker.zachodniopomorskie"
    ]
    return regionNames
  }
}
