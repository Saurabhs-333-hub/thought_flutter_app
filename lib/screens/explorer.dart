import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/rendering/sliver_staggered_grid.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:thought/utils/utils.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isShowUsers = false;
    return Scaffold(
      appBar: AppBar(
          title: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(label: Text("Search a User!")),
        onFieldSubmitted: (String _) {
          setState(() {
            isShowUsers = true;
            // showSnackBar(context, _);
          });
          // showSnackBar(context, _);
        },
      )),
      body: _searchController.text != ''
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading....");
                }
                return ListView.builder(
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage((snapshot.data as dynamic)
                            .docs[index]['profilePic']),
                      ),
                      title: Text(
                          (snapshot.data as dynamic).docs[index]['username']),
                    );
                  },
                );
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading....");
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: (snapshot.data as dynamic).docs.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover),
                    ),
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.count(
                      (index % 3 == 0) ? 2 : 1, (index % 4 == 0) ? 2 : 1),
                );
              }),
    );
  }
}
