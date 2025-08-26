import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  final String title;
  bool isDone;
  Task({required this.title, this.isDone = false});
}

class ToDo {
  final String id;
  final String title;
  final List<Task> tasks;
  ToDo({required this.id, required this.title, this.tasks = const []});
}

class ToDoCard extends StatelessWidget {
  final ToDo todo;
  final VoidCallback onDelete;
  final Function(Task) onTaskToggle;
  final bool isGridView;

  const ToDoCard({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onTaskToggle,
    this.isGridView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(66, 131, 181, 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 16,
                          color: Color.fromRGBO(143, 153, 162, 1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${todo.tasks.length} Tasks",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color.fromRGBO(143, 153, 162, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDelete,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color.fromRGBO(133, 34, 33, 1),
                ),
              ),
            ],
          ),
          const Divider(color: Color.fromRGBO(225, 233, 239, 1), height: 24),

          if (isGridView)
            Flexible(
              child: ListView.builder(
                itemCount: todo.tasks.length,
                itemBuilder: (context, index) =>
                    _buildTaskRow(todo.tasks[index]),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todo.tasks.length,
              itemBuilder: (context, index) => _buildTaskRow(todo.tasks[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(Task task) {
    return InkWell(
      onTap: () => onTaskToggle(task),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              task.isDone
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: task.isDone
                  ? const Color.fromRGBO(66, 181, 112, 1)
                  : Color.fromRGBO(143, 153, 162, 1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 12,
                  color: task.isDone
                      ? Color.fromRGBO(66, 181, 112, 1)
                      : Color.fromRGBO(143, 153, 162, 1),
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: task.isDone
                      ? Color.fromRGBO(66, 181, 112, 1)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTodoPopUp extends StatefulWidget {
  final Function(String title, List<String> taskTitles) onAdd;

  const AddTodoPopUp({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddTodoPopUp> createState() => _AddTodoPopUpState();
}

class _AddTodoPopUpState extends State<AddTodoPopUp> {
  final _titleController = TextEditingController();
  final List<TextEditingController> _taskControllers = [];

  @override
  void initState() {
    super.initState();
    _addTaskField();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _taskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTaskField() {
    setState(() {
      _taskControllers.add(TextEditingController());
    });
  }

  void _removeTaskField(int index) {
    _taskControllers[index].dispose();
    setState(() {
      _taskControllers.removeAt(index);
    });
  }

  void _submit() {
    final taskTitles = _taskControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    widget.onAdd(_titleController.text, taskTitles);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add a new To-Do',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'To-Do Title'),
            ),
            const SizedBox(height: 16),
            const Text('Tasks'),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _taskControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Task ${index + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _removeTaskField(index),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
              onPressed: _addTaskField,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Add To-Do'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressCircleCard extends StatelessWidget {
  final String title;
  final double progress;

  const ProgressCircleCard({
    Key? key,
    required this.title,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(236, 243, 248, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(
              painter: CircularProgressPainter(
                progress: progress,
                progressColor: const Color.fromRGBO(66, 131, 181, 1),
                backgroundColor: const Color.fromRGBO(213, 222, 228, 1),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildLegend(
                color: const Color.fromRGBO(66, 131, 181, 1),
                text: 'Done',
              ),
              const SizedBox(height: 8),
              _buildLegend(
                color: const Color.fromRGBO(213, 222, 228, 1),
                text: 'Pending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.1415926535 / 180), // Start angle
      progress * 360 * (3.1415926535 / 180), // Sweep angle
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldPainter = oldDelegate as CircularProgressPainter;
    return oldPainter.progress != progress;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const MyHomePage(title: 'To-Do App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ToDo> _todos = [
    ToDo(
      id: '1',
      title: 'Study Flutter course',
      tasks: [
        Task(title: 'Review lecture slides', isDone: true),
        Task(title: 'Solve examples', isDone: true),
        Task(title: 'Review assignments', isDone: false),
      ],
    ),
    ToDo(
      id: '2',
      title: 'Go to the gym',
      tasks: [
        Task(title: 'Cardio', isDone: true),
        Task(title: 'Upper', isDone: true),
        Task(title: 'Lower', isDone: false),
        Task(title: 'Calisthenics', isDone: false),
      ],
    ),
    ToDo(
      id: '3',
      title: 'Prepare Food',
      tasks: [
        Task(title: 'Meal prep for the week', isDone: false),
        Task(title: 'Clean the kitchen', isDone: true),
      ],
    ),
    ToDo(
      id: '4',
      title: 'Final Project',
      tasks: [
        Task(title: 'Plan features', isDone: true),
        Task(title: 'Design UI', isDone: true),
        Task(title: 'Develop backend', isDone: false),
        Task(title: 'Test application', isDone: false),
      ],
    ),
  ];

  late int _todoIdCounter;

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _toggleTaskStatus(ToDo todo, Task task) {
    setState(() {
      final taskIndex = todo.tasks.indexOf(task);
      todo.tasks[taskIndex].isDone = !todo.tasks[taskIndex].isDone;
    });
  }

  void _addTodo(String title, List<String> taskTitles) {
    if (title.isEmpty) {
      return;
    }

    final newTasks = taskTitles
        .where((taskTitle) => taskTitle.isNotEmpty)
        .map((taskTitle) => Task(title: taskTitle))
        .toList();

    final newTodo = ToDo(
      id: _todoIdCounter.toString(),
      title: title,
      tasks: newTasks,
    );

    setState(() {
      _todos.add(newTodo);
      _todoIdCounter++;
    });
  }

  void _showAddToDoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: AddTodoPopUp(onAdd: _addTodo),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _todoIdCounter = _todos.length + 1;
  }

  Widget _buildWideLayout(
    double todosProgress,
    double tasksProgress,
    int pendingTasks,
    int doneTasks,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450, minWidth: 380),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(42, 42, 42, 0.25),
                    spreadRadius: -2,
                    blurRadius: 50,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 20,
                            child: Image.asset(
                              "images/Edges_logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const Text(
                          "To-Do",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(66, 131, 181, 1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100,
                              margin: const EdgeInsets.all(20),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  "images/IMG_4446.png",
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Good morning, Malak",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Have a wonderful day!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(143, 153, 162, 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(66, 131, 181, 0.1),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 30,
                            color: Color.fromRGBO(66, 131, 181, 1),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(181, 135, 66, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  8.0,
                                  8.0,
                                  8.0,
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.rotate_left_sharp,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const Text(
                                "Pending",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "$pendingTasks tasks",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(66, 181, 112, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  8.0,
                                  8.0,
                                  8.0,
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const Text(
                                "Done",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "$doneTasks tasks",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ProgressCircleCard(
                            title: 'To-Dos',
                            progress: todosProgress,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ProgressCircleCard(
                            title: 'Tasks',
                            progress: tasksProgress,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideEnough = constraints.maxWidth > 500;
                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Text(
                        "My To-Dos",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    if (isWideEnough)
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 1.8,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final todo = _todos[index];
                          return ToDoCard(
                            key: ValueKey(todo.id),
                            todo: todo,
                            onDelete: () => _deleteTodo(todo.id),
                            onTaskToggle: (task) =>
                                _toggleTaskStatus(todo, task),
                            isGridView: true,
                          );
                        }, childCount: _todos.length),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final todo = _todos[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ToDoCard(
                              key: ValueKey(todo.id),
                              todo: todo,
                              onDelete: () => _deleteTodo(todo.id),
                              onTaskToggle: (task) =>
                                  _toggleTaskStatus(todo, task),
                              isGridView: false,
                            ),
                          );
                        }, childCount: _todos.length),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(int pendingTasks, int doneTasks) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20,
                  child: Image.asset(
                    "images/Edges_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                "To-Do",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(66, 131, 181, 1),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                margin: const EdgeInsets.only(
                  right: 20.0,
                  top: 20.0,
                  bottom: 20.0,
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("images/IMG_4446.png"),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Good morning, Malak",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Have a wonderful day!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(143, 153, 162, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(66, 131, 181, 0.1),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 30,
                  color: Color.fromRGBO(66, 131, 181, 1),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(181, 135, 66, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.rotate_left_sharp,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Text(
                      "Pending",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "$pendingTasks tasks",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(66, 181, 112, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "$doneTasks tasks",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "My To-Dos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final todo = _todos[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ToDoCard(
                  key: ValueKey(todo.id),
                  todo: todo,
                  onDelete: () => _deleteTodo(todo.id),
                  onTaskToggle: (task) => _toggleTaskStatus(todo, task),
                  isGridView: false,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int pendingTasks = 0;
    int doneTasks = 0;
    for (var todo in _todos) {
      for (var task in todo.tasks) {
        if (task.isDone) {
          doneTasks++;
        } else {
          pendingTasks++;
        }
      }
    }
    final int totalTasks = doneTasks + pendingTasks;
    final double tasksProgress = (totalTasks == 0)
        ? 0.0
        : doneTasks / totalTasks;

    int completedTodoLists = 0;
    for (var todo in _todos) {
      if (todo.tasks.isNotEmpty && todo.tasks.every((task) => task.isDone)) {
        completedTodoLists++;
      }
    }
    final int totalTodoLists = _todos.length;
    final double todosProgress = (totalTodoLists == 0)
        ? 0.0
        : completedTodoLists / totalTodoLists;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double wideLayoutBreakpoint = 700;
        final bool isWide = constraints.maxWidth > wideLayoutBreakpoint;

        return Scaffold(
          backgroundColor: Colors.white,

          floatingActionButton: isWide
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddToDoDialog(),
                  backgroundColor: const Color.fromRGBO(66, 131, 181, 1),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Add To-Do",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                )
              : FloatingActionButton(
                  onPressed: () => _showAddToDoDialog(),
                  backgroundColor: const Color.fromRGBO(66, 131, 181, 1),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
          body: SafeArea(
            child: isWide
                ? _buildWideLayout(
                    todosProgress,
                    tasksProgress,
                    pendingTasks,
                    doneTasks,
                  )
                : _buildNarrowLayout(pendingTasks, doneTasks),
          ),
        );
      },
    );
  }
}
