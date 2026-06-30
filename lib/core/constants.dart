import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/route_model.dart';

export 'colors.dart';

class AppConstants {
  static const String appName = 'ProConnect';
  static const String defaultCity = 'Harare';
  static const String legalUrl = 'https://proconnect.com/legal';
  static const String userAgentPackageName = 'com.proconnect.app';
  static const LatLng defaultCenter = LatLng(-17.8292, 31.0522);
  static const double defaultZoom = 14.0;
  static const String currentAddress = '1 Sam Nujoma Street';

  static const List<Map<String, dynamic>> homeServices = [
    {
      'icon': Icons.directions_car,
      'title': 'City Rides',
      'subtitle': 'Request a ride around town',
      'route': '/ride',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Courier',
      'subtitle': 'Deliver packages within the city',
      'route': '/courier',
    },
    {
      'icon': Icons.map_outlined,
      'title': 'Intercity',
      'subtitle': 'Book trips between cities',
      'route': '/intercity',
    },
    {
      'icon': Icons.fire_truck_outlined,
      'title': 'Freight',
      'subtitle': 'Move cargo over 20 kg',
      'route': '/freight',
    },
  ];

  static const List<Map<String, dynamic>> serviceCategories = [
    {'icon': Icons.plumbing, 'title': 'Plumber'},
    {'icon': Icons.electrical_services, 'title': 'Electrician'},
    {'icon': Icons.build, 'title': 'Mechanic'},
    {'icon': Icons.cleaning_services, 'title': 'Cleaner'},
    {'icon': Icons.format_paint, 'title': 'Painter'},
    {'icon': Icons.grass, 'title': 'Gardener'},
    {'icon': Icons.handyman, 'title': 'Carpenter'},
    {'icon': Icons.computer, 'title': 'Technician'},
    {'icon': Icons.kitchen, 'title': 'Appliance Repair'},
    {'icon': Icons.brush, 'title': 'Beauty Professional'},
    {'icon': Icons.school, 'title': 'Tutor'},
    {'icon': Icons.work, 'title': 'Freelancer'},
    {'icon': Icons.more_horiz, 'title': 'Other'},
  ];

  static final List<Map<String, dynamic>> sampleServiceProviders = [
    {
      'id': 'provider_1',
      'name': 'Aida Crew',
      'photoUrl': '',
      'bio': 'Experienced electrician and home systems expert.',
      'category': 'Electrician',
      'skills': ['Wiring', 'Lighting', 'Fault repair'],
      'certifications': ['Certified Electrician'],
      'experienceYears': 8,
      'serviceRadiusKm': 10,
      'rating': 4.9,
      'reviews': 42,
      'available': true,
      'completedJobs': 120,
      'hourlyRate': 35,
      'distanceKm': 3.4,
    },
    {
      'id': 'provider_2',
      'name': 'Sami Plumbing',
      'photoUrl': '',
      'bio': 'Fast plumbing service with emergency support.',
      'category': 'Plumber',
      'skills': ['Leak repair', 'Pipe installation', 'Drain cleaning'],
      'certifications': ['Licensed Plumber'],
      'experienceYears': 6,
      'serviceRadiusKm': 10,
      'rating': 4.8,
      'reviews': 36,
      'available': true,
      'completedJobs': 98,
      'hourlyRate': 30,
      'distanceKm': 5.1,
    },
    {
      'id': 'provider_3',
      'name': 'Mia AutoCare',
      'photoUrl': '',
      'bio': 'Mobile mechanic for vehicle diagnostics and repair.',
      'category': 'Mechanic',
      'skills': ['Engine repair', 'Oil change', 'Diagnostics'],
      'certifications': ['Automotive Technician'],
      'experienceYears': 10,
      'serviceRadiusKm': 10,
      'rating': 4.7,
      'reviews': 58,
      'available': false,
      'completedJobs': 140,
      'hourlyRate': 40,
      'distanceKm': 7.2,
    },
  ];

  static final List<AppRouteModel> popularRoutes = [
    AppRouteModel(title: 'Harare - Bulawayo', count: 134),
    AppRouteModel(title: 'Harare - Mutare', count: 157),
    AppRouteModel(title: 'Harare - Gweru', count: 132),
    AppRouteModel(title: 'Harare - Chinhoyi', count: 117),
    AppRouteModel(title: 'Harare - Masvingo', count: 103),
  ];

  static const List<Map<String, String>> kazakhstanCities = [
    {'name': 'Harare', 'region': 'Harare Province'},
    {'name': 'Bulawayo', 'region': 'Bulawayo Province'},
    {'name': 'Mutare', 'region': 'Manicaland'},
    {'name': 'Gweru', 'region': 'Midlands'},
    {'name': 'Chitungwiza', 'region': 'Mashonaland East'},
    {'name': 'Masvingo', 'region': 'Masvingo Province'},
    {'name': 'Kadoma', 'region': 'Mashonaland West'},
    {'name': 'Kwekwe', 'region': 'Midlands'},
    {'name': 'Bindura', 'region': 'Mashonaland Central'},
    {'name': 'Chinhoyi', 'region': 'Mashonaland West'},
    {'name': 'Victoria Falls', 'region': 'Matabeleland North'},
    {'name': 'Beitbridge', 'region': 'Matabeleland South'},
    {'name': 'Hwange', 'region': 'Matabeleland North'},
    {'name': 'Marondera', 'region': 'Mashonaland East'},
    {'name': 'Karoi', 'region': 'Mashonaland West'},
  ];

  static const List<Map<String, dynamic>> rideTariffs = [
    {
      'id': 'economy',
      'label': 'Economy',
      'subtitle': 'Up to 4 seats',
      'icon': Icons.directions_car_outlined,
    },
    {
      'id': 'comfort',
      'label': 'Comfort',
      'subtitle': 'Up to 4 seats',
      'icon': Icons.directions_car_filled_outlined,
    },
    {
      'id': 'suv',
      'label': 'SUV',
      'subtitle': 'Up to 6 seats',
      'icon': Icons.airport_shuttle_outlined,
    },
    {
      'id': 'minivan',
      'label': 'Minivan',
      'subtitle': 'Up to 7 seats',
      'icon': Icons.directions_bus_outlined,
    },
  ];

  static const List<String> rideWishes = [
    'Quiet ride',
    'No smoking',
    'Luggage friendly',
    'Child seat',
    'Children on board',
    'Pets allowed',
  ];

  static const List<String> destinationSuggestions = [
    'Harare International Airport',
    'Victoria Falls',
    'Bulawayo Station',
    'Samora Machel Avenue',
    'Avondale Shopping Centre',
    'City Centre',
    'Mbare Market',
  ];

  static const List<String> freightBodyTypes = [
    'Curtain',
    'Insulated',
    'Van',
    'Refrigerated',
    'Flatbed',
  ];

  static const List<String> helpServices = [
    'City Rides',
    'Intercity',
    'Courier',
    'Freight',
    'Service Booking',
  ];

  static const List<String> helpMore = ['App Questions', 'About ProConnect'];
}

