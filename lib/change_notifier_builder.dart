library change_notifier_builder;

import 'package:flutter/widgets.dart';

class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatefulWidget {
  /// A simple `ChangeNotifier` builder to be used with a MVVM pattern.
  const ChangeNotifierBuilder({
    Key? key,
    required this.model,
    required this.builder,
  }) : super(key: key);

  /// A `ChangeNotifier` model.
  final T model;

  /// Callback to provide access to the Widget's context and `ChangeNotifier` model.
  final Widget Function(BuildContext context, T model) builder;

  @override
  _ChangeNotifierBuilderState<T> createState() =>
      _ChangeNotifierBuilderState<T>();
}

class _ChangeNotifierBuilderState<T extends ChangeNotifier>
    extends State<ChangeNotifierBuilder<T>> {
  @override
  void initState() {
    widget.model.addListener(_listener);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChangeNotifierBuilder<T> oldWidget) {
    if (widget.model != oldWidget.model) {
      _migrate(widget.model, oldWidget.model, _listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.model.removeListener(_listener);
    super.dispose();
  }

  void _migrate(Listenable a, Listenable b, void Function() listener) {
    a.removeListener(listener);
    b.addListener(listener);
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.model);
  }
}
