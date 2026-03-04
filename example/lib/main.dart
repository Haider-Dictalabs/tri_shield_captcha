import 'package:auth_captcha/auth_captcha.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TriShield CAPTCHA Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleListPage(),
    );
  }
}

class ExampleListPage extends StatelessWidget {
  const ExampleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TriShield CAPTCHA Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            'Basic Integration',
            'Simple CAPTCHA widget integration',
            Icons.security,
                () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const BasicExamplePage(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            'Login Form',
            'CAPTCHA in a login form',
            Icons.login,
                () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const LoginFormExample(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildExampleCard(
            context,
            'Registration Form',
            'CAPTCHA in a registration form',
            Icons.person_add,
                () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const RegistrationFormExample(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// ============================================================================
// BASIC EXAMPLE
// ============================================================================

class BasicExamplePage extends StatefulWidget {
  const BasicExamplePage({super.key});

  @override
  State<BasicExamplePage> createState() => _BasicExamplePageState();
}

class _BasicExamplePageState extends State<BasicExamplePage> {
  bool _isVerified = false;
  String? _verificationUuid;

  void _handleCaptchaResult(CaptchaResult result) {
    setState(() {
      _isVerified = result.isVerified;
      _verificationUuid = result.uuid;
    });

    if (result.isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Verified! UUID: ${result.uuid ?? "N/A"}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Integration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Basic CAPTCHA Integration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This example shows the simplest way to integrate TriShield CAPTCHA.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Status Card
            if (_isVerified)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'CAPTCHA Verified!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (_verificationUuid != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'UUID: $_verificationUuid',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // CAPTCHA Widget
            AuthCaptcha(
              apiKey: 'YOUR_API_KEY_HERE', // Replace with your API key
              webUrl: 'https://yourwebsite.com', // Replace with your URL
              onResult: _handleCaptchaResult,
            ),

            const SizedBox(height: 24),

            // Action Button
            ElevatedButton.icon(
              onPressed: _isVerified
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proceeding with verified CAPTCHA...'),
                  ),
                );
              }
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LOGIN FORM EXAMPLE
// ============================================================================

class LoginFormExample extends StatefulWidget {
  const LoginFormExample({super.key});

  @override
  State<LoginFormExample> createState() => _LoginFormExampleState();
}

class _LoginFormExampleState extends State<LoginFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _captchaVerified = false;
  String? _verificationUuid;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleCaptchaResult(CaptchaResult result) {
    setState(() {
      _captchaVerified = result.isVerified;
      _verificationUuid = result.uuid;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_captchaVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the CAPTCHA verification'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successful! UUID: ${_verificationUuid ?? "N/A"}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // CAPTCHA
              AuthCaptcha(
                apiKey: 'YOUR_API_KEY_HERE',
                webUrl: 'https://yourwebsite.com',
                onResult: _handleCaptchaResult,
              ),

              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// REGISTRATION FORM EXAMPLE
// ============================================================================

class RegistrationFormExample extends StatefulWidget {
  const RegistrationFormExample({super.key});

  @override
  State<RegistrationFormExample> createState() =>
      _RegistrationFormExampleState();
}

class _RegistrationFormExampleState extends State<RegistrationFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _captchaVerified = false;
  String? _verificationUuid;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCaptchaResult(CaptchaResult result) {
    setState(() {
      _captchaVerified = result.isVerified;
      _verificationUuid = result.uuid;
    });
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_captchaVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the CAPTCHA verification'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful! UUID: ${_verificationUuid ?? "N/A"}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.person_add_outlined, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outlined),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Terms Checkbox
              CheckboxListTile(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() => _agreeToTerms = value ?? false);
                },
                title: const Text('I agree to the Terms and Conditions'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // CAPTCHA
              AuthCaptcha(
                apiKey: 'YOUR_API_KEY_HERE',
                webUrl: 'https://yourwebsite.com',
                onResult: _handleCaptchaResult,
              ),

              const SizedBox(height: 24),

              // Register Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
