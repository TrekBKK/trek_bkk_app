import 'package:flutter/material.dart';

// Colors
const primaryColor = Color(0xFF972D07);
const secondaryColor = Color(0xFFA49694);
const lightColor = Color(0xFFFAE1A6);
const dividerColor = Color(0xFFEFEFEF);

// Typography
const headline20 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const headline22 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
const headline48 = TextStyle(fontSize: 48, fontWeight: FontWeight.w700);
const body12 = TextStyle(fontSize: 12);
const body14 = TextStyle(fontSize: 14);

const placeTypes = {
  "accounting": "Accounting",
  "airport": "Airport",
  "amusement_park": "Amusement Park",
  "aquarium": "Aquarium",
  "art_gallery": "Art Gallery",
  "atm": "ATM",
  "bakery": "Bakery",
  "bank": "Bank",
  "bar": "Bar",
  "beauty_salon": "Beauty Salon",
  "bicycle_store": "Bicycle Store",
  "book_store": "Book Store",
  "bowling_alley": "Bowling Alley",
  "bus_station": "Bus Station",
  "cafe": "Cafe",
  "campground": "Campground",
  "car_dealer": "Car Dealer",
  "car_rental": "Car Rental",
  "car_repair": "Car Repair",
  "car_wash": "Car Wash",
  "casino": "Casino",
  "cemetery": "Cemetery",
  "church": "Church",
  "city_hall": "City Hall",
  "clothing_store": "Clothing Store",
  "convenience_store": "Convenience Store",
  "courthouse": "Courthouse",
  "dentist": "Dentist",
  "department_store": "Department Store",
  "doctor": "Doctor",
  "drugstore": "Drugstore",
  "electrician": "Electrician",
  "electronics_store": "Electronics Store",
  "embassy": "Embassy",
  "fire_station": "Fire Station",
  "florist": "Florist",
  "funeral_home": "Funeral Home",
  "furniture_store": "Furniture Store",
  "gas_station": "Gas Station",
  "gym": "Gym",
  "hair_care": "Hair Care",
  "hardware_store": "Hardware Store",
  "hindu_temple": "Hindu Temple",
  "home_goods_store": "Home Goods Store",
  "hospital": "Hospital",
  "insurance_agency": "Insurance Agency",
  "jewelry_store": "Jewelry Store",
  "laundry": "Laundry",
  "lawyer": "Lawyer",
  "library": "Library",
  "light_rail_station": "Light Rail Station",
  "liquor_store": "Liquor Store",
  "local_government_office": "Local Government Office",
  "locksmith": "Locksmith",
  "lodging": "Lodging",
  "meal_delivery": "Meal Delivery",
  "meal_takeaway": "Meal Takeaway",
  "mosque": "Mosque",
  "movie_rental": "Movie Rental",
  "movie_theater": "Movie Theater",
  "moving_company": "Moving Company",
  "museum": "Museum",
  "night_club": "Night Club",
  "painter": "Painter",
  "park": "Park",
  "parking": "Parking",
  "pet_store": "Pet Store",
  "pharmacy": "Pharmacy",
  "physiotherapist": "Physiotherapist",
  "plumber": "Plumber",
  "police": "Police",
  "post_office": "Post Office",
  "primary_school": "Primary School",
  "real_estate_agency": "Real Estate Agency",
  "restaurant": "Restaurant",
  "roofing_contractor": "Roofing Contractor",
  "rv_park": "RV Park",
  "school": "School",
  "secondary_school": "Secondary School",
  "shoe_store": "Shoe Store",
  "shopping_mall": "Shopping Mall",
  "spa": "Spa",
  "stadium": "Stadium",
  "storage": "Storage",
  "store": "Store",
  "subway_station": "Subway Station",
  "supermarket": "Supermarket",
  "synagogue": "Synagogue",
  "taxi_stand": "Taxi Stand",
  "tourist_attraction": "Tourist Attraction",
  "train_station": "Train Station",
  "transit_station": "Transit Station",
  "travel_agency": "Travel Agency",
  "university": "University",
  "veterinary_care": "Veterinary Care",
  "zoo": "Zoo",

  // Table 2: Additional types returned by the Places service

  "administrative_area_level_1": "Administrative area level 1",
  "administrative_area_level_2": "Administrative area level 2",
  "administrative_area_level_3": "Administrative area level 3",
  "administrative_area_level_4": "Administrative area level 4",
  "administrative_area_level_5": "Administrative area level 5",
  "administrative_area_level_6": "Administrative area level 6",
  "administrative_area_level_7": "Administrative area level 7",
  "archipelago": "Archipelago",
  "colloquial_area": "Colloquial area",
  "continent": "Continent",
  "country": "Country",
  "establishment": "Establishment",
  "finance": "Finance",
  "floor": "Floor",
  "food": "Food",
  "general_contractor": "General contractor",
  "geocode": "Geocode",
  "health": "Health",
  "intersection": "Intersection",
  "landmark": "Landmark",
  "locality": "Locality",
  "natural_feature": "Natural feature",
  "neighborhood": "Neighborhood",
  "place_of_worship": "Place of worship",
  "plus_code": "Plus code",
  "point_of_interest": "Point of interest",
  "political": "Political",
  "post_box": "Post box",
  "postal_code": "Postal code",
  "postal_code_prefix": "Postal code prefix",
  "postal_code_suffix": "Postal code suffix",
  "postal_town": "Postal town",
  "premise": "Premise",
  "room": "Room",
  "route": "Route",
  "street_address": "Street address",
  "street_number": "Street number",
  "sublocality": "Sublocality",
  "sublocality_level_1": "Sublocality level 1",
  "sublocality_level_2": "Sublocality level 2",
  "sublocality_level_3": "Sublocality level 3",
  "sublocality_level_4": "Sublocality level 4",
  "sublocality_level_5": "Sublocality level 5",
  "subpremise": "Subpremise",
  "town_square": "Town square"
};
