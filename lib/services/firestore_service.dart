import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  // Add a new task
  Future<void> addTask(Task task) {
    return tasksCollection.add(task.toMap());
  }

  // Update a task
  Future<void> updateTask(Task task) {
    return tasksCollection.doc(task.id).update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String taskId) {
    return tasksCollection.doc(taskId).delete();
  }

  // Get all tasks
  Stream<List<Task>> getTasks() {
    return tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}
