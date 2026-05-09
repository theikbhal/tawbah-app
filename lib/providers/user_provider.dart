import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/database_helper.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _currentUser;
  int _dailyCount = 0;
  DateTime _selectedDate = DateTime.now();

  AppUser? get currentUser => _currentUser;
  int get dailyCount => _dailyCount;
  DateTime get selectedDate => _selectedDate;

  Future<void> loadUsers() async {
    final users = await DatabaseHelper.instance.getUsers();
    if (users.isNotEmpty) {
      _currentUser = users.first; // Default to first user for now
      await refreshDailyCount();
    }
  }

  Future<void> setCurrentUser(AppUser user) async {
    _currentUser = user;
    await refreshDailyCount();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) async {
    _selectedDate = date;
    await refreshDailyCount();
    notifyListeners();
  }

  Future<void> refreshDailyCount() async {
    if (_currentUser != null) {
      _dailyCount = await DatabaseHelper.instance.getZikirCount(_currentUser!.id!, _selectedDate);
      notifyListeners();
    }
  }

  Future<void> incrementZikir(int amount) async {
    if (_currentUser != null) {
      await DatabaseHelper.instance.updateZikirCount(_currentUser!.id!, _selectedDate, amount);
      _dailyCount += amount;
      notifyListeners();
    }
  }

  int calculateDailyTarget(DateTime date) {
    if (_currentUser == null) return 3000;
    
    final start = _currentUser!.startDate;
    final monthsDiff = (date.year - start.year) * 12 + date.month - start.month;
    
    // Month 1: 3000, Month 2: 4000, ..., Month 10+: 12000
    int target = 3000 + (monthsDiff * 1000);
    if (target > 12000) target = 12000;
    if (target < 3000) target = 3000;
    
    return target;
  }

  double get progress {
    final target = calculateDailyTarget(_selectedDate);
    if (target == 0) return 0;
    double p = _dailyCount / target;
    return p > 1.0 ? 1.0 : p;
  }

  Future<void> addUser(String name, String role) async {
    final user = AppUser(
      name: name,
      role: role,
      startDate: DateTime.now(),
    );
    final id = await DatabaseHelper.instance.createUser(user);
    _currentUser = AppUser(id: id, name: name, role: role, startDate: user.startDate);
    await refreshDailyCount();
    notifyListeners();
  }
}
