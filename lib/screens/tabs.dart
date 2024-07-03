import 'package:flutter/material.dart';
import 'package:recipe_diary/data/Provider/favorite_provider.dart';
import 'package:recipe_diary/screens/categories.dart';
import 'package:recipe_diary/screens/filter_screen.dart';
import 'package:recipe_diary/screens/meals.dart';
import 'package:recipe_diary/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_diary/data/Provider/filter_provider.dart';

const kinitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String indentifier) async {
    Navigator.of(context).pop();
    if (indentifier == 'filter') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FilterScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeal = ref.watch(filteredMealsProvider);
    Widget activeScreen = CategoryItem(
      availableMeal: availableMeal,
    );
    var activeScreenTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activeScreen = MealsScreen(
        meals: favoriteMeals,
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
