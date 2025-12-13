import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full name'),
                onSaved: (v) => _name = v?.trim() ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _email = v?.trim() ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password (6+)'),
                obscureText: true,
                onSaved: (v) => _password = v ?? '',
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars' : null,
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
                          await auth.register(_email, _password, displayName: _name);
                          Navigator.pushReplacementNamed(context, Routes.main);
                        } catch (e) {
                          setState(() {
                            _error = e.toString();
                            _loading = false;
                          });
                        }
                      },
                      child: const SizedBox(width: double.infinity, child: Center(child: Text('Register'))),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.login),
                child: const Text('Already have an account? Login'),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
