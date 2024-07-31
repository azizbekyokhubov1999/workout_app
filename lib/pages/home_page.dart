import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/pages/workout_page.dart';

import '../data/workout_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  // just for check
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }
  //text controller
  final newWorkoutNameController = TextEditingController();

  //method for creating new workout
  void createNewWorkout(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Create new workout'),
          content: TextField(
            controller: newWorkoutNameController,
          ),
          actions: [
            // save button
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

  // function for going workout page
  void goToWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName,)));
  }

  //saving function workout
  void save(){
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

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
    newWorkoutNameController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return  Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Workout Tracker'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: value.workoutList.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
              onPressed: () => goToWorkoutPage(value.getWorkoutList()[index].name),
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
