import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/models/tasks_model.dart';
import 'package:task_manager_app/core/view_models/tasks_view_model.dart';
import 'package:task_manager_app/database/database_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách công việc"),
        backgroundColor: Color(0xFF3B5998),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: GestureDetector(
        // Dùng GestureDetector để phát hiện khi người dùng nhấn ra ngoài TextField
        onTap: () {
          // Khi nhấn ra ngoài, bỏ focus khỏi TextField
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm công việc...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: Consumer<TaskListViewModel>(
                builder: (context, snapshot, child) {
                  snapshot.loadTasks();

                  // Lọc công việc theo từ khóa tìm kiếm
                  List<TaskModel> filteredTasks = snapshot.tasks
                      .where((task) =>
                          task.title!.toLowerCase().contains(_searchQuery) ||
                          (task.description != null &&
                              task.description!.toLowerCase().contains(_searchQuery)))
                      .toList();

                  if (filteredTasks.isNotEmpty) {
                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        TaskModel task = filteredTasks[index];

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                offset: Offset(0, 2),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12.0),
                            title: Text(task.title ?? "", style: TextStyle(fontSize: 18.0)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ngày hoàn thành: ${task.dueDate}",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  task.description ?? "",
                                  style: TextStyle(fontSize: 14.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (task.status == 0) {
                                      DatabaseHelper().markAsCompleted(task.id!);
                                    } else {
                                      DatabaseHelper().markAsPending(task.id!);
                                    }
                                  },
                                  child: Icon(
                                    task.status == 0
                                        ? Icons.check_box_outline_blank
                                        : Icons.check_box,
                                    color: task.status == 0 ? Colors.grey : Colors.green,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    bool? confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Xóa công việc"),
                                          content: Text("Bạn có chắc chắn muốn xóa công việc này không?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text("Hủy"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                var req = await snapshot.removeTask(task.id);
                                                if (req == true) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Đã xóa công việc")),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Không tìm thấy công việc bạn muốn xóa")),
                                                  );
                                                  snapshot.loadTasks();
                                                }
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text("Xóa"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      await DatabaseHelper().deleteTask(task.id!);
                                      snapshot.loadTasks();
                                    }
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/add_task', arguments: task);
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Chưa có công việc nào"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_task', arguments: null);
        },
        tooltip: 'Thêm công việc',
        backgroundColor: Color(0xFF3B5998),
        child: Icon(Icons.add),
      ),
    );
  }
}
