import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Todoservice {
  static Future<void> addTodo({required String text}) async {
    await FirebaseFirestore.instance.collection('todos').add({
      'todo': text,
      'time': Timestamp.now(),
    });
  }

  static Future<void> deleteTodo({required String id}) async {
    await FirebaseFirestore.instance.collection('todos').doc(id).delete();
  }

  static Stream<List<Map<String, dynamic>>> fetchTodos() {
    return FirebaseFirestore.instance
        .collection("todos")
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) {
                    final data = doc.data();
                    return {
                      'id': doc.id,
                      'todo': data['todo'] ?? '',
                      'time': data['time'] ?? Timestamp.now(),
                    };
                  })
                  .where((element) => element['id'] != null)
                  .toList(),
        );
  }

  static Future<void> updateTodo({
    required String id,
    required String text,
  }) async {
    await FirebaseFirestore.instance.collection('todos').doc(id).update({
      'todo': text,
    });
  }
}