import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/data.dart';
import '../models/nav.dart';

class Settings extends ChangeNotifier {
  String url;
  String apiKey;
  String limit;
  bool isLoad;

  Future<void> load() async {
    // First load preferences
    isLoad = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    url = (prefs.getString('url') ?? 'http://');
    apiKey = (prefs.getString('apiKey') ?? '');
    limit = (prefs.getString('limit') ?? '500');
    isLoad = false;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('url', url.replaceAll(RegExp(r"/+$"), ''));
    prefs.setString('apiKey', apiKey);
    prefs.setString('limit', limit);

    // Refresh to populate the interface
    final data = Provider.of<Data>(context, listen: false);
    final nav = Provider.of<Nav>(context, listen: false);
    data.refresh();
    nav.set(null, null, 'All');
  }

  Future<void> clear(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    // Refresh to clear-up the interface
    final data = Provider.of<Data>(context, listen: false);
    final nav = Provider.of<Nav>(context, listen: false);
    data.refresh();
    nav.set(null, null, 'All');
  }
}
