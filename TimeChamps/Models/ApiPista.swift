//
//  ApiPista.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 09/05/25.
//

struct ApiPista: Decodable {
    let nome: String
    let geojson: GeoJSON

    struct GeoJSON: Decodable {
        let features: [Feature]

        struct Feature: Decodable {
            let geometry: Geometry

            struct Geometry: Decodable {
                let coordinates: [[Double]]
            }
        }
    }
}
