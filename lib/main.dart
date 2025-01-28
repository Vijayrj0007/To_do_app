import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Map<String, String>> tasks = [];

  void _addOrEditTask({int? index}) {
    String title = index != null ? tasks[index]['title']! : '';
    String description = index != null ? tasks[index]['description'] ?? '' : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index != null ? 'Edit Task' : 'Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
                controller: TextEditingController(text: title),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description (optional)'),
                onChanged: (value) {
                  description = value;
                },
                controller: TextEditingController(text: description),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(index != null ? 'Update' : 'Add'),
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    if (index != null) {
                      tasks[index] = {'title': title, 'description': description};
                    } else {
                      tasks.add({'title': title, 'description': description});
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
      ),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks yet!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(tasks[index]['title']!),
                    subtitle: Text(tasks[index]['description'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _addOrEditTask(index: index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                    onTap: () => _addOrEditTask(index: index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
