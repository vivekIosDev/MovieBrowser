//
//  AppDelegate.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//


import Foundation
struct Results : Codable {
	let adult : Bool?
	let backdrop_path : String?
	let genre_ids : [Int]?
	let id : Int?
	let original_language : String?
	let original_title : String?
	let overview : String?
	let popularity : Double?
	let poster_path : String?
	let release_date : String?
	let title : String?
	let video : Bool?
	let vote_average : Double?
	let vote_count : Int?

	enum CodingKeys: String, CodingKey {

		case adult = "adult"
		case backdrop_path = "backdrop_path"
		case genre_ids = "genre_ids"
		case id = "id"
		case original_language = "original_language"
		case original_title = "original_title"
		case overview = "overview"
		case popularity = "popularity"
		case poster_path = "poster_path"
		case release_date = "release_date"
		case title = "title"
		case video = "video"
		case vote_average = "vote_average"
		case vote_count = "vote_count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
		backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
		genre_ids = try values.decodeIfPresent([Int].self, forKey: .genre_ids)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		original_language = try values.decodeIfPresent(String.self, forKey: .original_language)
		original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
		overview = try values.decodeIfPresent(String.self, forKey: .overview)
		popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
		poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
		release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		video = try values.decodeIfPresent(Bool.self, forKey: .video)
		vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
		vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
	}

}
