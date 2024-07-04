import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_diary/models/mealdata.dart';
import 'package:recipe_diary/widgets/meal_item_trait.dart';

import 'package:transparent_image/transparent_image.dart';


class MealItem extends StatelessWidget {
  const MealItem({required this.selectMeal,required this.meal, super.key});

  final Meal meal;
  final void Function() selectMeal;
  String get mealComplexity{
    return meal.complexity.name[0].toUpperCase() + meal.complexity.name.substring(1);
  }
  String get mealAffordable{
    return meal.affordability.name[0].toUpperCase() + meal.affordability.name.substring(1);
  }
  @override
  Widget build(context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap:selectMeal,
        child: Stack(
          children: [
            Hero(
              tag: meal.id,
              child: FadeInImage(
                fit: BoxFit.cover,
                width: double.infinity,
                height: 230,
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, // very long text ..
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(icon: Icons.schedule, label:'${meal.duration} min'),
                        const SizedBox(width: 12,),
                        MealItemTrait(icon: Icons.yard_sharp, label: mealComplexity),
                        const SizedBox(width: 12,),
                        MealItemTrait(icon: Icons.currency_rupee, label: mealAffordable),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
