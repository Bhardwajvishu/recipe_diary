import 'package:flutter/material.dart';
import 'package:recipe_diary/data/dummydata.dart';
import 'package:recipe_diary/models/category.dart';
import 'package:recipe_diary/models/mealdata.dart';
import 'package:recipe_diary/screens/meals.dart';
import 'package:recipe_diary/widgets/category_grid_item.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key, required this.availableMeal});

  final List<Meal> availableMeal;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 368),
      upperBound: 1,
      lowerBound: 0,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeal
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(meals: filteredMeals, title: category.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
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
                _selectCategory(context, category);
              },
            ),
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0.0, 0.3),
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.decelerate),
        ),
        child: child,
      ),
    );
  }
}
