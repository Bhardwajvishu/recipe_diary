import "package:recipe_diary/data/dummydata.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealsProvider = Provider((ref) => dummyMeals);
