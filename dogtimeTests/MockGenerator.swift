//
//  MockGenerator.swift
//  dogtimeTests
//
//  Created by Chris Petimezas on 16/10/23.
//

import Foundation

class MockGenerator {

    static func getBreeds() -> Data {
        """
        {"message":{"affenpinscher":[],"african":[],"airedale":[],"akita":[],"appenzeller":[],"australian":["shepherd"],"basenji":[],"beagle":[],"bluetick":[],"borzoi":[],"bouvier":[],"boxer":[],"brabancon":[],"briard":[],"buhund":["norwegian"],"bulldog":["boston","english","french"],"bullterrier":["staffordshire"],"cattledog":["australian"],"cavapoo":[],"chihuahua":[],"chow":[],"clumber":[],"cockapoo":[],"collie":["border"],"coonhound":[],"corgi":["cardigan"],"cotondetulear":[],"dachshund":[],"dalmatian":[],"dane":["great"],"deerhound":["scottish"],"dhole":[],"dingo":[],"doberman":[],"elkhound":["norwegian"],"entlebucher":[],"eskimo":[],"finnish":["lapphund"],"frise":["bichon"],"germanshepherd":[],"greyhound":["italian"],"groenendael":[],"havanese":[],"hound":["afghan","basset","blood","english","ibizan","plott","walker"],"husky":[],"keeshond":[],"kelpie":[],"komondor":[],"kuvasz":[],"labradoodle":[],"labrador":[],"leonberg":[],"lhasa":[],"malamute":[],"malinois":[],"maltese":[],"mastiff":["bull","english","tibetan"],"mexicanhairless":[],"mix":[],"mountain":["bernese","swiss"],"newfoundland":[],"otterhound":[],"ovcharka":["caucasian"],"papillon":[],"pekinese":[],"pembroke":[],"pinscher":["miniature"],"pitbull":[],"pointer":["german","germanlonghair"],"pomeranian":[],"poodle":["medium","miniature","standard","toy"],"pug":[],"puggle":[],"pyrenees":[],"redbone":[],"retriever":["chesapeake","curly","flatcoated","golden"],"ridgeback":["rhodesian"],"rottweiler":[],"saluki":[],"samoyed":[],"schipperke":[],"schnauzer":["giant","miniature"],"segugio":["italian"],"setter":["english","gordon","irish"],"sharpei":[],"sheepdog":["english","shetland"],"shiba":[],"shihtzu":[],"spaniel":["blenheim","brittany","cocker","irish","japanese","sussex","welsh"],"spitz":["japanese"],"springer":["english"],"stbernard":[],"terrier":["american","australian","bedlington","border","cairn","dandie","fox","irish","kerryblue","lakeland","norfolk","norwich","patterdale","russell","scottish","sealyham","silky","tibetan","toy","welsh","westhighland","wheaten","yorkshire"],"tervuren":[],"vizsla":[],"waterdog":["spanish"],"weimaraner":[],"whippet":[],"wolfhound":["irish"]},"status":"success"}
        """.data(using: .utf8)!
    }

    static func getBreedData() -> Data {
        """
        {"message":["https://images.dog.ceo/breeds/akita/512px-Ainu-Dog.jpg","https://images.dog.ceo/breeds/akita/512px-Akita_inu.jpg","https://images.dog.ceo/breeds/akita/Akita_Inu_dog.jpg","https://images.dog.ceo/breeds/akita/Akita_hiking_in_Shpella_e_Pellumbasit.jpg","https://images.dog.ceo/breeds/akita/An_Akita_Inu_resting.jpg","https://images.dog.ceo/breeds/akita/Japaneseakita.jpg"],"status":"success"}
        """.data(using: .utf8)!
    }
}
