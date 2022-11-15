import 'package:flutter/material.dart';
import '../utils/data.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) =>
          {FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        appBar: AppBar(
          title: const TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Tìm kiếm',
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.3,
                child: const Divider(),
              ),
            );
          },
          itemCount: peoples.length,
          itemBuilder: (BuildContext context, int index) {
            Map people = peoples[index];
            return Padding(
              padding: const EdgeInsets.only(right: 20, left: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    people['dp'],
                  ),
                  radius: 25,
                ),
                contentPadding: const EdgeInsets.all(0),
                title: Text(people['name']),
                subtitle: Text(people['status']),
                trailing: people['isAccept']
                    ? TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      )
                    : TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
