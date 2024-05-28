import 'package:flutter/material.dart';
import 'models/member.dart';

class AdherentsPage extends StatefulWidget {
  const AdherentsPage({Key? key}) : super(key: key);

  @override
  State<AdherentsPage> createState() => _AdherentsPageState();
}

class _AdherentsPageState extends State<AdherentsPage> {
  List<Member> adherents = [];
  List<Member> filteredAdherents = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  int? editIndex;

  @override
  void initState() {
    super.initState();
    filteredAdherents = adherents;
  }

  void addToList() {
    String email = emailController.text;
    if (nameController.text.isNotEmpty && email.isNotEmpty && isValidEmail(email)) {
      setState(() {
        if (editIndex != null) {
          adherents[editIndex!] = Member(name: nameController.text, email: email);
          editIndex = null;
        } else {
          adherents.add(Member(name: nameController.text, email: email));
        }
        nameController.clear();
        emailController.clear();
        filterList('');
      });
    } else if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
    }
  }

  bool isValidEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void deleteItem(int index) {
    setState(() {
      adherents.removeAt(index);
      filterList('');
    });
  }

  void filterList(String query) {
    setState(() {
      filteredAdherents = adherents.where((member) {
        return member.name.toLowerCase().contains(query.toLowerCase()) ||
               member.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void editItem(int index) {
    setState(() {
      nameController.text = adherents[index].name;
      emailController.text = adherents[index].email;
      editIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adherents Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: AdherentSearchDelegate(adherents, filterList));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter adherent\'s name',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                suffixIcon: nameController.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          nameController.clear();
                        },
                      ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter adherent\'s email',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                suffixIcon: emailController.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          emailController.clear();
                        },
                      ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addToList,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                child: const Text('Add Member'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAdherents.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(filteredAdherents[index].name.substring(0, 1).toUpperCase()),
                      ),
                      title: Text(filteredAdherents[index].name),
                      subtitle: Text(filteredAdherents[index].email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editItem(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdherentSearchDelegate extends SearchDelegate {
  final List<Member> adherents;
  final Function(String) onQueryChanged;

  AdherentSearchDelegate(this.adherents, this.onQueryChanged);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onQueryChanged(query);
    final results = adherents
        .where((adherent) => adherent.name.toLowerCase().contains(query.toLowerCase()) ||
                             adherent.email.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final adherent = results[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(adherent.name.substring(0, 1).toUpperCase()),
          ),
          title: Text(adherent.name),
          subtitle: Text(adherent.email),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => Navigator.of(context).pop(),  // Fermer la vue de recherche
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = adherents
        .where((adherent) => adherent.name.toLowerCase().contains(query.toLowerCase()) ||
                             adherent.email.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final adherent = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(adherent.name.substring(0, 1).toUpperCase()),
          ),
          title: Text(adherent.name),
          subtitle: Text(adherent.email),
          onTap: () {
            query = adherent.name;
            showResults(context);
          },
        );
      },
    );
  }
}

