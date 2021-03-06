import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/screens/detail_screen.dart';
import 'package:vanilla/widgets/todo_item.dart';
import 'package:vanilla/widgets/typedefs.dart';

class TodoList extends StatelessWidget {
  final List<Todo> filteredTodos;
  final bool loading;
  final TodoAdder addTodo;
  final TodoRemover removeTodo;
  final TodoUpdater updateTodo;

  TodoList({
    @required this.filteredTodos,
    @required this.loading,
    @required this.addTodo,
    @required this.removeTodo,
    @required this.updateTodo,
  })
      : super(key: ArchSampleKeys.todoList);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: loading
          ? new Center(
              child: new CircularProgressIndicator(
              key: ArchSampleKeys.todosLoading,
            ))
          : new ListView.builder(
              key: ArchSampleKeys.todoList,
              itemCount: filteredTodos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = filteredTodos[index];

                return new TodoItem(
                  todo: todo,
                  onDismissed: (direction) {
                    _removeTodo(context, todo);
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (_) {
                          return new DetailScreen(
                            todo: todo,
                            onDelete: () => _removeTodo(context, todo),
                            addTodo: addTodo,
                            updateTodo: updateTodo,
                          );
                        },
                      ),
                    );
                  },
                  onCheckboxChanged: (complete) {
                    updateTodo(todo, complete: !todo.complete);
                  },
                );
              },
            ),
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    removeTodo(todo);

    Scaffold.of(context).showSnackBar(
          new SnackBar(
            key: ArchSampleKeys.snackbar,
            duration: new Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            content: new Text(
              ArchSampleLocalizations.of(context).todoDeleted(todo.task),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            action: new SnackBarAction(
              label: ArchSampleLocalizations.of(context).undo,
              onPressed: () {
                addTodo(todo);
              },
            ),
          ),
        );
  }
}
