import 'package:flutter/material.dart';
import 'package:recipe_diary/data/dummydata.dart';
import 'package:recipe_diary/models/category.dart';
import 'package:recipe_diary/models/mealdata.dart';
import 'package:recipe_diary/screens/meals.dart';
import 'package:recipe_diary/widgets/category_grid_item.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key,required this.onToggleFavorite,required this.availableMeal});

  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availableMeal;
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeal
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(meals: filteredMeals, title: category.title,onToggleFavorite: onToggleFavorite,),
      ),
    );
  }

  @override
  Widget build(context) {
    return GridView(
        padding: const EdgeInsets.all(21),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              selectCategory: () {
                _selectCategory(context,category);
              },
            ),
        ],
      );
  }
}
