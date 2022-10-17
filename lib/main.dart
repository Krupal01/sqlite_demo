import 'package:flutter/material.dart';
import 'package:sqlite_demo/DB/db_manager.dart';
import 'package:sqlite_demo/model/users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DbManager dbManager;

  Future<int> addData() async {
    Users users =
        Users(id: 0, userName: "userName", mobileNumber: "mobileNumber");
    return await dbManager.insertUser(users);
  }

  @override
  void initState() {
    dbManager = DbManager();

    dbManager.initDB().whenComplete(
      () async {
        await addData();
        await addData();
        await addData();
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sqlite Demo"),
      ),
      body: FutureBuilder(
        future: dbManager.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].userName),
                    subtitle: Column(
                      children: [
                        Text(snapshot.data![index].mobileNumber),
                        ElevatedButton(
                            onPressed: () async {
                              await dbManager
                                  .deleteUsers(snapshot.data![index]);
                              setState(() {});
                            },
                            child: const Text("delete")),
                        ElevatedButton(
                            onPressed: () async {
                              Users users = snapshot.data![index];
                              users.userName = "username2";
                              users.mobileNumber = "sadfadf";
                              await dbManager.updateUsers(users);
                              setState(() {});
                            },
                            child: const Text("update")),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text("Data not found"),
            );
          }
        },
      ),
    );
  }
}
