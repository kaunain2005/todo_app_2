import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (v) => _email = v?.trim() ?? '',
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  onSaved: (v) => _password = v ?? '',
                  validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 chars' : null,
                ),
                const SizedBox(height: 18),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();
                          setState(() {
                            _loading = true;
                            _error = null;
                          });

                          try {
                            await auth.signIn(_email, _password);
                            Navigator.pushReplacementNamed(context, Routes.main);
                          } catch (e) {
                            setState(() {
                              _error = e.toString();
                              _loading = false;
                            });
                          }
                        },
                        child: const SizedBox(width: double.infinity, child: Center(child: Text('Login'))),
                      ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, Routes.register),
                  child: const Text('Don\'t have an account? Register'),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
