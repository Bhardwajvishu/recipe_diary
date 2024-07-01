import 'package:flutter/material.dart';
import 'package:recipe_diary/data/dummydata.dart';
import 'package:recipe_diary/models/mealdata.dart';
import 'package:recipe_diary/screens/categories.dart';
import 'package:recipe_diary/screens/filter_screen.dart';
import 'package:recipe_diary/screens/meals.dart';
import 'package:recipe_diary/widgets/main_drawer.dart';

const kinitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List<Meal> _selectedFavoriteMeal = [];
  Map<Filter, bool> selectedFilter = kinitialFilter;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleFavoriteMealList(Meal meal) {
    final containFavorite = _selectedFavoriteMeal.contains(meal);

    if (containFavorite) {
      setState(() {
        _selectedFavoriteMeal.remove(meal);
        _showInfoMessage('This meal is no longer favorite.');
      });
    } else {
      setState(() {
        _selectedFavoriteMeal.add(meal);
        _showInfoMessage('This meal is added to favorite!');
      });
    }
  }

  void _setScreen(String indentifier) async {
    Navigator.of(context).pop();
    if (indentifier == 'filter') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilter: selectedFilter,
          ),
        ),
      );
      setState(() {
        selectedFilter = result ?? kinitialFilter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeal = dummyMeals.where((meal) {
      if (selectedFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (selectedFilter[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (selectedFilter[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (selectedFilter[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activeScreen = CategoryItem(
      onToggleFavorite: _toggleFavoriteMealList,
      availableMeal: availableMeal,
    );
    var activeScreenTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activeScreen = MealsScreen(
        meals: _selectedFavoriteMeal,
        onToggleFavorite: _toggleFavoriteMealList,
      );
      activeScreenTitle = 'Favorite';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activeScreenTitle),
      ),
      body: activeScreen,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
