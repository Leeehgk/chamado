import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Person {
  final String name;
  final int ramal;
  final String ip;
  final String problem;
  String email; // Alteração feita aqui

  Person({
    required this.name,
    required this.ramal,
    required this.ip,
    required this.problem,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ramal': ramal,
      'ip': ip,
      'problem': problem,
      'email': email,
    };
  }
}

class PersonForm extends StatefulWidget {
  const PersonForm({Key? key}) : super(key: key);

  @override
  _PersonFormState createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ramalController = TextEditingController();
  final _ipController = TextEditingController();
  final _problemController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ramalController.dispose();
    _ipController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  void _savePerson() async {
    if (_formKey.currentState!.validate()) {
      final person = Person(
        name: _nameController.text.trim(),
        ramal: int.parse(_ramalController.text.trim()),
        ip: _ipController.text.trim(),
        problem: _problemController.text.trim(),
        email: '', // Atualize essa linha com o e-mail correto
      );

      // Obtém a instância atual do FirebaseAuth
      final FirebaseAuth auth = FirebaseAuth.instance;

      // Verifica se há um usuário logado
      if (auth.currentUser != null) {
        // Obtém o e-mail do usuário logado
        final String? email = auth.currentUser!.email;

        // Atualiza o campo email do objeto person
        if (email != null) {
          person.email = email;
        }
      }

      FirebaseFirestore.instance.collection('people').add(person.toMap());

      _nameController.clear();
      _ramalController.clear();
      _ipController.clear();
      _problemController.clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados atualizados com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: const Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira seu nome !';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ramalController,
                    decoration: InputDecoration(
                      labelText: 'Ramal',
                      prefixIcon: const Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira seu ramal';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor insira um ramal Valido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: 'ip',
                      prefixIcon: const Icon(Icons.auto_fix_high),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira seu IP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: null,
                    controller: _problemController,
                    decoration: InputDecoration(
                      labelText: 'problema',
                      prefixIcon: const Icon(Icons.assignment),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira seu problema';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _savePerson,
                    child: const Text(
                      'Salvar',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonList extends StatelessWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('people').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Text('Carregando...');
        }
        final people = snapshot.data!.docs
            .map((doc) => Person(name: doc['name'], ramal: doc['ramal'], ip: doc['ip'], problem: doc['problem'], email: doc['email']))
            .toList();
        return ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];
            return ListTile(
              title: Text(person.name),
              trailing: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmação'),
                        content: Text('Deseja realmente excluir ${person.name}?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Excluir'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              deleteData(person.name);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.delete),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => launchChatWithEmail(person.email),
                  ),
                );
              },
              onLongPress: () {
                // Iniciar um chat com a pessoa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDetailsScreen(person: person),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

launchChatWithEmail(String email) {
  // Lógica para iniciar um chat com o e-mail fornecido
  // Isso pode envolver a utilização de pacotes de chat ou integrações externas
  }


class PersonDetailsScreen extends StatefulWidget {
  final Person person;

  const PersonDetailsScreen({Key? key, required this.person}) : super(key: key);

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  late TextEditingController _ramalController;
  late TextEditingController _ipController;
  late TextEditingController _problemController;

  @override
  void initState() {
    super.initState();
    _ramalController = TextEditingController(text: widget.person.ramal.toString());
    _ipController = TextEditingController(text: widget.person.ip.toString());
    _problemController = TextEditingController(text: widget.person.problem.toString());
  }

  @override
  void dispose() {
    _ramalController.dispose();
    _ipController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  Future<void> updateRamal() async {
    final ramal = int.tryParse(_ramalController.text);
    final ip = _ipController.text;
    final problem = _problemController.text;
    if (_ramalController.text.isEmpty || ip.isEmpty || problem.isEmpty) {
      // Mostra um erro se o valor do ramal ou do IP estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, Verifique se os campos estão digitados'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (ramal == null) {
      // Mostra um erro se o valor do ramal não for válido
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, insira um valor de ramal válido.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Busca o documentoID pelo nome da pessoa
    QuerySnapshot buscaCampo = await FirebaseFirestore.instance
        .collection("people")
        .where("name", isEqualTo: widget.person.name)
        .get();

    // Verifica Se o documento existe e se possui os campos, se sim, atualiza o ramal ( Update ).
    if (buscaCampo.docs.isNotEmpty) {
      var documentId = buscaCampo.docs[0].id;
      await FirebaseFirestore.instance
          .collection('people')
          .doc(documentId)
          .update({'ramal': ramal, 'ip': ip, 'problem': problem});
    }

    // Mostra uma mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Dados atualizados com sucesso!'),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _ramalController,
              decoration: InputDecoration(
                labelText: 'Ramal',
                prefixIcon: const Icon(Icons.phone),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor insira um ramal válido!';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'IP',
                prefixIcon: const Icon(Icons.auto_fix_high),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor insira um IP válido!';
                }
                // adicione a expressão regular para permitir o ponto
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: null,
              controller: _problemController,
              decoration: InputDecoration(
                labelText: 'Problema',
                prefixIcon: const Icon(Icons.assignment),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor insira um IP válido!';
                }
                // adicione a expressão regular para permitir o ponto
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Atualizar os dados'),
                        content: Text('Você gostaria de atualizar os dados da pessoa ${widget.person.name}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // fecha o diálogo
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              updateRamal();
                              Navigator.of(context).pop(); // fecha o diálogo
                            },
                            child: const Text('Atualizar'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Atualizar dados'),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void deleteData(String name) async {
  // Busca o documento no Firestore baseado no nome
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("people")
      .where("name", isEqualTo: name)
      .get();

  // Exclui o documento encontrado
  for (var doc in querySnapshot.docs) {
    doc.reference.delete();
  }
}

