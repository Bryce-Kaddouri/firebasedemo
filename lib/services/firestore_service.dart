// import firestore package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService{
    // function to create project into users/userId/projects/projectId
    Future<void> createProject(String projectName, String desc) async {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project

        DocumentReference? _projectRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .add({
                'name': projectName,
                'description': desc,
                'createdAt': DateTime.now(),
                'updatedAt': DateTime.now(),
            });
    }

    // function to stream all projects from users/userId/projects
    Stream<QuerySnapshot> getProjects() {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        return FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .snapshots();
    }

    // function to update project into users/userId/projects/projectId
    Future<void> updateProject(String projectId, String projectName, String desc) async {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        DocumentReference? projectRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId);

        // update project data
        await projectRef.update({
            'name': projectName,
            'description': desc,
            'updatedAt': DateTime.now(),
        });

    }

    // function to delete project into users/userId/projects/projectId
    Future<void> deleteProject(String projectId) async {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        DocumentReference? projectRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId);

        // delete project data
        await projectRef.delete();
    }

    // function to create task into users/userId/projects/projectId/tasks/taskId
    Future<void> createTask(String projectId, String taskName, String desc) async {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        DocumentReference? _taskRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId)
            .collection('tasks')
            .add({
                'name': taskName,
                'description': desc,
                'createdAt': DateTime.now(),
                'updatedAt': DateTime.now(),
                'isDone': false,
            });
    }

    // function to get all tasks from users/userId/projects/projectId/tasks
    Stream<QuerySnapshot> getTasks(String projectId) {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        return FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId)
            .collection('tasks')
            .snapshots();
    }

    // function to update task into users/userId/projects/projectId/tasks/taskId
    Future updateTask(String projectId, String taskId, bool? isDone, String? name, String? description) async{
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
            throw Exception('User is not authenticated');
        }

        DocumentReference? taskRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId)
            .collection('tasks')
            .doc(taskId);

        Map<String, dynamic> data = {
            'updatedAt': DateTime.now(),
        };
        if (isDone != null) {
            data['isDone'] = isDone;
        }
        if (name != null) {
            data['name'] = name;
        }
        if (description != null) {
            data['description'] = description;
        }


        if (data.isNotEmpty) {
            await taskRef.update(data);
        }else{
            throw Exception('No data to update');
        }
    }

    // function to delete task into users/userId/projects/projectId/tasks/taskId
    Future<void> deleteTask(String projectId, String taskId) async {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        DocumentReference? taskRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId)
            .collection('tasks')
            .doc(taskId);

        // delete project data
        await taskRef.delete();
    }

    // function to get all tasks from users/userId/projects/projectId/tasks
    Stream<QuerySnapshot> getTasksByStatus(String projectId, bool isDone) {
        // get current user
        User? user = FirebaseAuth.instance.currentUser;
        // check if user is authenticated
        if (user == null) {
            throw Exception('User is not authenticated');
        }
        // get reference to the project
        return FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('projects')
            .doc(projectId)
            .collection('tasks')
            .where('isDone', isEqualTo: isDone)
            .snapshots();
    }


}