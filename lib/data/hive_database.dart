import 'package:hive/hive.dart';
import 'package:workout_app/datetime/data_time.dart';
import 'package:workout_app/models/exercise.dart';

import '../models/workout.dart';

class HiveDatabase{

  // reference hive box
  final _myBox = Hive.box("workout_database");

  //check it already data stored, if not record the start date
  bool previousDataExists(){
    if(_myBox.isEmpty){
      print("previous data does not exists");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    }
    else{
      print("previous data does exists");
      return true;
    }
  }

 //return start date
  String getStartDate(){
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Workout> workouts){
    //convert workout objects into lists of strings
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if(exerciseCompleted(workouts)){
      _myBox.put("COMPLETION_DATE_${todaysDateYYYYMMDD()}", 1);
    }
    else{
      _myBox.put("COMPLETION_DATE_${todaysDateYYYYMMDD()}", 0);
    }

    //save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", workoutList);
  }

  //read data and return list of workouts
  List<Workout>readFromDatabase(){
    List<Workout>mySaveWorkouts =[];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create workout objects
    for(int i=0; i<workoutNames.length; i++){
      List<Exercise> exercisesInEachWorkout =[];

      for(int j = 0; j<exerciseDetails[i].length; j++){
        // add each exercise
        exercisesInEachWorkout.add(
          Exercise(
              name: exerciseDetails[i][j][0],
              weight: exerciseDetails[i][j][1],
              reps: exerciseDetails[i][j][2],
              sets: exerciseDetails[i][j][3],
              isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      //create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      //add individual workout
      mySaveWorkouts.add(workout);
    }
    return mySaveWorkouts;
  }

  //check exercise completion
  bool exerciseCompleted(List<Workout> workouts){
    for(var workout in workouts){
      for(var exercise in workout.exercises){
        if(exercise.isCompleted){
          return true;
        }
      }
    }
    return false;
  }

  //return completion status
  int getCompletionStatus(String yyyymmdd){
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  //converts workout objects into a list
  List<String> convertObjectToWorkoutList(List<Workout> workouts){
    List<String> workoutList = [

    ];
    for(int i=0; i<workoutList.length; i++){
      workoutList.add(
        workouts[i].name,
      );
    }
    return workoutList;
  }

  //converts the exercises in a workout object into a list of String
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts){
  List<List<List<String>>> exerciseList = [

  ];

  for(int i=0; i<workouts.length; i++){
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [

    ];

    for(int j = 0; j < exercisesInWorkout.length; j++){
      List<String> individualExercise = [

      ];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
}