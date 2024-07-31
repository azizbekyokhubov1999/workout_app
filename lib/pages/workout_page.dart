
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/exercise_tile.dart';
import 'package:workout_app/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  //checkbox pressed
  void onCheckBoxChanged(String workoutName, String exerciseName){
    Provider.of<WorkoutData>(context, listen: false)
        .checkOfExercise(workoutName, exerciseName);
  }

  //text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();


  //saving function exercise
  void save(){
    String exerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        exerciseName,
        weight,
        reps,
        sets
    );

    Navigator.pop(context);
    clear();
  }

  //cancel function
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  //clear function
  void clear(){
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  //method for creating new exercise
  void createNewExercise(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add new exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //exercise name
              TextField(
                controller: exerciseNameController,
              ),

              //weight
              TextField(
                controller: weightController,
              ),

              //reps
              TextField(
                controller: repsController,
              ),

              //sets
              TextField(
                controller: setsController,
              )
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: save,
              child: Text('Save'),
            ),
            //cancel button
            MaterialButton(
              onPressed: cancel,
              child: Text('Cancel'),
            )
          ],
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: Text(widget.workoutName),
            centerTitle: true,
          ),
          body: ListView.builder(
              itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
              itemBuilder: (context, index) => ExerciseTile(
                  name: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                  weight: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .weight,
                  reps: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .reps,
                  sets: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .sets,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onCheckBoxChanged: (val) => onCheckBoxChanged(
                  widget.workoutName,
                  value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                ),
              ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewExercise,
            child: Icon(Icons.add),
          ),
        ),
    );
  }
}
