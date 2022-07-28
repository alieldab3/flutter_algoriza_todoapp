import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/tasks_database.dart';
import '../../models/task.dart';
import '../shared_widgets/custom_button.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<TaskItem> tasksShown = [];
  bool isLoading = false;

  @override
  void initState() {
    refreshTasks();
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);
    tasksShown = await Provider.of<Tasks>(context, listen: false).getAllTasks();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // final tasksData = Provider.of<Tasks>(context, listen: false);
    print(tasksShown);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Board'),
        bottom: buildTabBar(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/schedule');
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => refreshTasks()),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasksShown.length,
                itemBuilder: (_, i) {
                  return buildCheckbox(tasksShown[i]);
                },
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Add a Task',
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed('/add-task')
                        .whenComplete(() => refreshTasks());
                  },
                ))
          ]),
        ),
      ),
    );
  }

  Widget buildCheckbox(TaskItem task) => ListTile(
        onTap: () {
          setState(() {
            task.toggleDoneStatus();
            Provider.of<Tasks>(context, listen: false).updateTask(task);
          });
        },
        leading: Transform.scale(
          scale: 1.3,
          child: Checkbox(
            activeColor: task.color,
            value: task.isDone,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            side: BorderSide(width: 1.5, color: task.color),
            onChanged: (value) {
              setState(() {
                task.toggleDoneStatus();
                Provider.of<Tasks>(context, listen: false).updateTask(task);
              });
            },
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontSize: 18),
          overflow: TextOverflow.fade,
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  task.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: task.color,
                onPressed: () {
                  task.toggleFavouriteStatus();
                  Provider.of<Tasks>(context, listen: false).updateTask(task);
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  Provider.of<Tasks>(context, listen: false)
                      .deleteTask(task.id!);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      );

  TabBar buildTabBar() {
    return TabBar(
      controller: _tabController,
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Colors.black,
      tabs: const [
        Tab(
          text: "All",
        ),
        Tab(
          text: "Completed",
        ),
        Tab(
          text: "Uncompleted",
        ),
        Tab(
          text: "Favourite",
        ),
      ],
      onTap: (index) {
        setState(() {
          if (index == 0) {
            //All
            tasksShown = Provider.of<Tasks>(context, listen: false).tasks;
          } else if (index == 1) {
            //Completed
            tasksShown =
                Provider.of<Tasks>(context, listen: false).findCompletedTasks();
          } else if (index == 2) {
            //Uncompleted
            tasksShown = Provider.of<Tasks>(context, listen: false)
                .findUncompletedTasks();
          } else if (index == 3) {
            //Favourites
            tasksShown =
                Provider.of<Tasks>(context, listen: false).findFavouriteTasks();
          }
        });
      },
    );
  }
}
