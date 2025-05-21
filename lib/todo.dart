import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/todoservice.dart';


class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  TextEditingController todocontroller = TextEditingController();

  List<String> todos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Container(
            padding: EdgeInsets.all(20),
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("to do List", style: TextStyle(color: Colors.black)),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todocontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 31, 91, 108),
                          hintText: "Enter your Task",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (todocontroller.text.trim().isNotEmpty) {
                          Todoservice.addTodo(text: todocontroller.text.trim());
                          todocontroller.clear();
                        }
                      },
                      child: Text("ADD+"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 42, 186, 78),
                        foregroundColor: const Color.fromARGB(255, 43, 48, 42),
                        shape: StadiumBorder(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: Todoservice.fetchTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> todos = snapshot.data!;
                        return ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(todos[index]['todo'] ?? " "),
                              trailing: Row(mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final todoid = todos[index]['id'];
                                      if (todoid == null) {
                                        return;
                                      }
                                      final editcontroller =
                                          TextEditingController(
                                            text: todos[index]['todo'],
                                          );
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("edit todo"),
                                            content: TextField(
                                              controller: editcontroller,
                                              decoration: InputDecoration(
                                                hintText: "edit todo",
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  final updatetext =
                                                      editcontroller.text.trim();
                                                  if (updatetext.isNotEmpty) {
                                                    Todoservice.updateTodo(
                                                      id: todoid,
                                                      text: updatetext,
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text("update"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Todoservice.deleteTodo(
                                        id: todos[index]['id'],
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}