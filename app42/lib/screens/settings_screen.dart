import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.userName, this.onSignOut});

  final String? userName;
  final Future<void> Function()? onSignOut;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSigningOut = false;

  String _computeInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r"\s+"))
        .where((segment) => segment.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) {
      return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
    }
    return parts.map((segment) => segment.substring(0, 1).toUpperCase()).join();
  }

  Future<void> _handleSignOut() async {
    final signOut = widget.onSignOut;
    if (signOut == null || _isSigningOut) {
      return;
    }

    setState(() => _isSigningOut = true);

    try {
      await signOut();
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.userName != null) ...[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: Text(
                            _computeInitials(widget.userName!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName!,
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                'Signed in with Google',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  FilledButton.tonalIcon(
                    onPressed:
                        widget.onSignOut == null || _isSigningOut ? null : _handleSignOut,
                    icon: _isSigningOut
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                scheme.onPrimaryContainer,
                              ),
                            ),
                          )
                        : const Icon(Icons.logout),
                    label: Text(_isSigningOut ? 'Signing out…' : 'Sign out'),
                  ),
                  if (widget.onSignOut == null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Sign-out is currently unavailable.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
