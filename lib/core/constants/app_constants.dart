class AppConstants {
  static const String appName = 'GameZone';
  static const String appSlogan = 'Votre paradis du gaming';
  static const String currency = '€';
  
  // Mock API or use Fake Store API
  static const String baseUrl = 'https://fakestoreapi.com';
  
  // Local storage keys
  static const String cartKey = 'cart_items';
  static const String ordersKey = 'orders';
  static const String userKey = 'user_data';
  
  // Gaming categories mapping
  static const Map<String, String> categoryMapping = {
    'electronics': 'Consoles & Accessoires',
    'jewelery': 'Éditions Collector',
    'men\'s clothing': 'Merchandising Homme',
    'women\'s clothing': 'Merchandising Femme',
  };
}
