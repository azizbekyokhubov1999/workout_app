import 'package:flutter/cupertino.dart';
import 'package:workout_app/data/hive_database.dart';
import 'package:workout_app/models/exercise.dart';

import '../models/workout.dart';

class WorkoutData extends ChangeNotifier{

  final db = HiveDatabase();

  /*
  Workout data structure

  1. this overall list contains the different workout
  2. each workout has a name, and list of exercises

   */

  List<Workout> workoutList = [
    Workout(
        name: 'Upper Body',
        exercises: [
          Exercise(
              name: 'Bicep curls',
              weight: "10",
              reps: "10",
              sets: "3",
          ),
        ],
    ),
    Workout(
      name: 'Lower Body',
      exercises: [
        Exercise(
          name: 'Squads',
          weight: "10",
          reps: "10",
          sets: "3",
        ),
      ],
    ),
  ];

  //if there are workouts already db, then get that workout list,
  void initializeWorkoutList(){
    if(db.previousDataExists()){
      workoutList = db.readFromDatabase();
    }
   // otherwise use default workout list
    else{
      db.saveToDatabase(workoutList);
    }

  }

  // get the list of workouts
 List<Workout> getWorkoutList(){
   return workoutList;
 }
  // getting the length of given workout
int numberOfExercisesInWorkout(String workoutName){
   Workout relevantWorkout = getRelevantWorkout(workoutName);
   return relevantWorkout.exercises.length;
}

  // add a workout
void addWorkout(String name){
   //adding new workout with blank
  workoutList.add(Workout(name: name, exercises: []));
  notifyListeners();
  db.saveToDatabase(workoutList);
}

 // add an exercise to a workout
void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){
   //find  relevant workout
Workout relevantWorkout = getRelevantWorkout(workoutName);

  relevantWorkout.exercises.add(
   Exercise(
       name: exerciseName,
       weight: weight,
       reps: reps,
       sets: sets
   ),
  );
  notifyListeners();
  db.saveToDatabase(workoutList);
}
 // checking exercise
void checkOfExercise(String workoutName, String exerciseName){
   Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

   // checking completed or not
  relevantExercise.isCompleted = !relevantExercise.isCompleted;

  notifyListeners();
   db.saveToDatabase(workoutList);
}

//method for return relevant workout using given workout name
  Workout getRelevantWorkout(String workoutName){
    Workout relevantWorkout =
    workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

//method for return relevant workout using given workout name + exercise
Exercise getRelevantExercise(String workoutName, String exerciseName){
   Workout relevantWorkout = getRelevantWorkout(workoutName);

   // then, finding the relevant exercise in this workout
  Exercise relevantExercise = relevantWorkout.exercises
   .firstWhere((exercise) => exercise.name == exerciseName);
  return relevantExercise;
}


}