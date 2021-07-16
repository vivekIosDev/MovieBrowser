//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//


import Foundation

class MovieListModel : Codable {
	let dates : Dates?
	let page : Int?
	let results : [Results]?
	let total_pages : Int?
	let total_results : Int?

	enum CodingKeys: String, CodingKey {

		case dates = "dates"
		case page = "page"
		case results = "results"
		case total_pages = "total_pages"
		case total_results = "total_results"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dates = try values.decodeIfPresent(Dates.self, forKey: .dates)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
		total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
		total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
	}

}


extension Decodable {
  init(from: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
    let decoder = JSONDecoder()
    self = try decoder.decode(Self.self, from: data)
  }
}
