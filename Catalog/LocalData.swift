import Foundation

public class LocalData {
    
    static func getDresses() -> [Dress] {
        let dresses = [
            Dress(name: ["Adelia"], imgName: "adelia", isSelected: false),
            Dress(name: ["Adora"], imgName: "Adora", isSelected: false),
            Dress(name: ["Adora z Trenem","Adora with Train","Adora con Tren"],
                  imgName: "adora z trenem", isSelected: false),
            Dress(name: ["Alicia"], imgName: "alicia", isSelected: false),
            Dress(name: ["Aurora"], imgName: "aurora", isSelected: false),
            Dress(name: ["Aurora z Aplikacją","Aurora with Application","Aurora con Aplique"],
                  imgName: "aurora1", isSelected: false),
            Dress(name: ["Bonita"], imgName: "bonita", isSelected: false),
            Dress(name: ["Bonita ze Spódnicą","Bonita with Skirt","Bonita con Falsa"],
                  imgName: "bonita3", isSelected: false),
            Dress(name: ["Cassandra"], imgName: "cassandra", isSelected: false),
            Dress(name: ["Diamantina"], imgName: "diamantina", isSelected: false),
            Dress(name: ["Dulce"], imgName: "dulce", isSelected: false),
            Dress(name: ["Elodia"], imgName: "elodia", isSelected: false),
            Dress(name: ["Elsa"], imgName: "elsa", isSelected: false),
            Dress(name: ["Felicia"], imgName: "felicia", isSelected: false),
            Dress(name: ["Ivette"], imgName: "ivette", isSelected: false),
            Dress(name: ["Luna"], imgName: "luna", isSelected: false),
            Dress(name: ["Micaela"], imgName: "Micaela", isSelected: false),
            Dress(name: ["Monica"], imgName: "monica", isSelected: false),
            Dress(name: ["Monica z Peleryną","Monica with Cape","Monica con Capa"],
                  imgName: "Monica Aplication", isSelected: false),
            Dress(name: ["Morena"], imgName: "morena", isSelected: false),
            Dress(name: ["Ofelia"], imgName: "ofelia", isSelected: false),
            Dress(name: ["Olimpia"], imgName: "olimpia", isSelected: false),
            Dress(name: ["Paloma"], imgName: "paloma", isSelected: false),
            Dress(name: ["Paola"], imgName: "paola", isSelected: false),
            Dress(name: ["Rebeca"], imgName: "rebeca", isSelected: false),
            Dress(name: ["Samantha"], imgName: "Samantha", isSelected: false),
            Dress(name: ["Samantha z Trenem","Samantha with Train","Samantha con Tren"],
                  imgName: "Samantha 1", isSelected: false),
            Dress(name: ["Susana"], imgName: "susana", isSelected: false)
        ]
        return dresses
    }
    
    static func getCountries() -> [Country] {
        let countries = [
            Country(name: ["Albania","Albania","Albania"], imgName: "albania"),
            Country(name: ["Andora","Andorra","Andorra"], imgName: "andorra"),
            Country(name: ["Armenia","Armenia","Armenia"], imgName: "armenia"),
            Country(name: ["Austria","Austria","Austria"], imgName: "austria"),
            Country(name: ["Azerbejdżan","Azerbaijan","Azerbaijan"], imgName: "azerbaijan"),
            Country(name: ["Białoruś","Belarus","Bielorusia"], imgName: "belarus"),
            Country(name: ["Belgia","Belgium","Bélgica"], imgName: "belgium"),
            Country(name: ["Bośnia i Hercegowina","Bosnia and Herzegovina","Bosnia y Herzegovina"], imgName: "bosnia_and_herzegovina"),
            Country(name: ["Bułgaria","Bulgaria","Bulgaria"], imgName: "bulgaria"),
            Country(name: ["Chorwacja","Croatia","Croacia"], imgName: "croatia"),
            Country(name: ["Cypr","Cyprus","Chipre"], imgName: "cyprus"),
            Country(name: ["Czechy","Czech Republic","República Checa"], imgName: "czech_republic"),
            Country(name: ["Dania","Denmark","Dinamarca"], imgName: "denmark"),
            Country(name: ["Estonia","Estonia","Estonia"], imgName: "estonia"),
            Country(name: ["Finlandia","Finland","Finlandia"], imgName: "finland"),
            Country(name: ["Francja","France","Francia"], imgName: "france"),
            Country(name: ["Gruzja","Georgia","Georgia"], imgName: "georgia"),
            Country(name: ["Niemcy","Germany","Alemania"], imgName: "germany"),
            Country(name: ["Grecja","Greece","Grecia"], imgName: "greece"),
            Country(name: ["Węgry","Hungary","Hungría"], imgName: "hungary"),
            Country(name: ["Islandia","Iceland","Islandia"], imgName: "iceland"),
            Country(name: ["Irlandia","Ireland","Irlanda"], imgName: "ireland"),
            Country(name: ["Włochy","Italy","Italia"], imgName: "italy"),
            Country(name: ["Kazachstan","Kazakhstan","Kazakhstan"], imgName: "kazakhstan"),
            Country(name: ["Kosowo","Kosovo","Kosovo"], imgName: "kosovo"),
            Country(name: ["Łotwa","Latvia","Letonia"], imgName: "latvia"),
            Country(name: ["Liechtenstein","Liechtenstein","Liechtenstein"], imgName: "liechtenstein"),
            Country(name: ["Litwa","Lithuania","Lituania"], imgName: "lithuania"),
            Country(name: ["Luksemburg","Luxembourg","Luxemburgo"], imgName: "luxembourg"),
            Country(name: ["Macedonia","Macedonia","Macedonia"], imgName: "macedonia"),
            Country(name: ["Malta","Malta","Malta"], imgName: "malta"),
            Country(name: ["Moldavia","Moldova","Moldavia"], imgName: "moldova"),
            Country(name: ["Monaco","Monaco","Monaco"], imgName: "monaco"),
            Country(name: ["Czarnogóra","Montenegro","Montenegro"], imgName: "montenegro"),
            Country(name: ["Holandia","Netherlands","Paises Bajos"], imgName: "netherlands"),
            Country(name: ["Norwegia","Norway","Noruega"], imgName: "norway"),
            Country(name: ["Polska","Poland","Polonia"], imgName: "poland"),
            Country(name: ["Portugalia","Portugal","Portugal"], imgName: "portugal"),
            Country(name: ["Rumunia","Romania","Rumania"], imgName: "romania"),
            Country(name: ["Rosja","Russia","Rusia"], imgName: "russia"),
            Country(name: ["San Marino","San Marino","San Marino"], imgName: "san_marino"),
            Country(name: ["Szkocja","Scotland","Escocia"], imgName: "scotland"),
            Country(name: ["Serbia","Serbia","Serbia"], imgName: "serbia"),
            Country(name: ["Słowacja","Slovakia","Eslovaquia"], imgName: "slovakia"),
            Country(name: ["Słowenia","Slovenia","Eslovenia"], imgName: "slovenia"),
            Country(name: ["Hiszpania","Spain","España"], imgName: "spain"),
            Country(name: ["Szwecja","Sweden","Suecia"], imgName: "sweden"),
            Country(name: ["Szwajcaria","Switzerland","Suiza"], imgName: "switzerland"),
            Country(name: ["Turcja","Turkey","Turquía"], imgName: "turkey"),
            Country(name: ["Ukraina","Ukraine","Ucrania"], imgName: "ukraine"),
            Country(name: ["Zjednoczone Królestwo","United Kingdom","Reino Unido"], imgName: "united_kingdom")
        ]
        return countries
    }
    static func getRegions() -> [[String]] {
        let regionNames = [
            ["dolnośląskie","dolnośląskie","dolnośląskie"],
            ["kujawsko-pomorskie","kujawsko-pomorskie","kujawsko-pomorskie"],
            ["lubelskie","lubelskie","lubelskie"],
            ["lubuskie","lubuskie","lubuskie"],
            ["łódzkie","łódzkie","łódzkie"],
            ["małopolskie","małopolskie","małopolskie"],
            ["mazowieckie","mazowieckie","mazowieckie"],
            ["opolskie","opolskie","opolskie"],
            ["podkarpackie","podkarpackie","podkarpackie"],
            ["podlaskie","podlaskie","podlaskie"],
            ["pomorskie","pomorskie","pomorskie"],
            ["śląskie","śląskie","śląskie"],
            ["świętokrzyskie","świętokrzyskie","świętokrzyskie"],
            ["warmińsko-mazurskie","warmińsko-mazurskie","warmińsko-mazurskie"],
            ["wielkopolskie","wielkopolskie","wielkopolskie"],
            ["zachodniopomorskie","zachodniopomorskie","zachodniopomorskie"]
        ]
        return regionNames
    }
}
