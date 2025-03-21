import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/models/tasks_model.dart';
import 'package:task_manager_app/core/view_models/tasks_view_model.dart';

class TaskAddScreen extends StatefulWidget {
  final TaskModel? task;
  const TaskAddScreen({super.key, required this.task});

  @override
  _TaskAddScreenState createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  _addTask(
    String title,
    String description,
    String dueDate,
    bool _isCompleted,
  ) {
    if (title.isNotEmpty && description.isNotEmpty && dueDate.isNotEmpty) {
      TaskModel newTask = TaskModel(
        title: title,
        description: description,
        status: _isCompleted ? 1 : 0,
        dueDate: dueDate,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );
      return newTask;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
    }
  }

  _updateTask(
    String title,
    String description,
    String dueDate,
    bool _isCompleted,
    TaskModel? oldTask,
  ) {
    if (title.isNotEmpty && description.isNotEmpty && dueDate.isNotEmpty) {
      oldTask?.title = title;
      oldTask?.description = description;
      oldTask?.dueDate = dueDate;
      oldTask?.updatedAt = DateTime.now().toString();
      oldTask?.status = _isCompleted ? 1 : 0;
      return oldTask;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.task != null) {
        context.read<TaskListViewModel>().setIsCompleted(
          widget.task!.status == 1 ? true : false,
        );
      } else {
        context.read<TaskListViewModel>().setIsCompleted(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(text: widget.task?.title);
    final _descriptionController = TextEditingController(
      text: widget.task?.description,
    );
    final _dueDateController = TextEditingController(
      text: widget.task?.dueDate,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B5998),
        title: Text(
          widget.task?.id == null
              ? "Thêm công việc mới"
              : "Chỉnh sửa công việc",
        ),
      ),
      body: Consumer<TaskListViewModel>(
        builder: (context, snapshot, child) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Tên công việc"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Mô tả công việc"),
                ),
                TextField(
                  controller: _dueDateController,
                  decoration: InputDecoration(
                    labelText: "Hạn hoàn thành (yyyy-mm-dd)",
                  ),
                ),
                Row(
                  children: [
                    Text("Hoàn thành"),
                    Checkbox(
                      activeColor: Colors.green,
                      value: snapshot.isCompleted,
                      onChanged: (value) {
                        snapshot.setIsCompleted(value!);
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (widget.task?.id == null) {
                      await snapshot
                          .addTask(
                            _addTask(
                              _titleController.text,
                              _descriptionController.text,
                              _dueDateController.text,
                              snapshot.isCompleted,
                            ),
                          )
                          .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Thêm công việc thành công",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          });
                    } else {
                      await snapshot
                          .updateTask(
                            _updateTask(
                              _titleController.text,
                              _descriptionController.text,
                              _dueDateController.text,
                              snapshot.isCompleted,
                              widget.task,
                            ),
                          )
                          .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Chỉnh sửa công việc thành công",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          });
                    }
                  },
                  child:Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF3B5998),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    width: 150,
                    child: Center(child: Text(widget.task?.id == null ? "Thêm" : "Chỉnh sửa"),),
                  ) 
                  
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
