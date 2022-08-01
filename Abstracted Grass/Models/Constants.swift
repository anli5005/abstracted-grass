//
//  Constants.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import MapKit

let filters: [(MKPointOfInterestCategory, String)] = [
    .airport: "Airports",
    .amusementPark: "Amusement Parks",
    .aquarium: "Aquariums",
    .atm: "ATMs",
    .bakery: "Bakeries",
    .bank: "Banks",
    .brewery: "Breweries",
    .cafe: "Cafes",
    .campground: "Campgrounds",
    .carRental: "Car Rentals",
    .evCharger: "EV Chargers",
    .fireStation: "Fire Stations",
    .fitnessCenter: "Fitness Centers",
    .foodMarket: "Food Markets",
    .gasStation: "Gas Stations",
    .hospital: "Hospitals",
    .hotel: "Hotels",
    .laundry: "Laundries",
    .library: "Libraries",
    .marina: "Marinas",
    .movieTheater: "Movie Theaters",
    .museum: "Museums",
    .nationalPark: "National Parks",
    .nightlife: "Nightlife",
    .park: "Parks",
    .parking: "Parking",
    .pharmacy: "Pharmacies",
    .police: "Police",
    .postOffice: "Post Offices",
    .publicTransport: "Public Transport",
    .restaurant: "Restaurants",
    .restroom: "Restrooms",
    .school: "Schools",
    .stadium: "Stadiums",
    .store: "Stores",
    .theater: "Theaters",
    .university: "Universities",
    .winery: "Wineries",
    .zoo: "Zoos"
].sorted(by: {
    $0.1 < $1.1
})
